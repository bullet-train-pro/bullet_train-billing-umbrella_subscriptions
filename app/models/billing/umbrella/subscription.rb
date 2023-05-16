class Billing::Umbrella::Subscription < ApplicationRecord
  belongs_to :team
  belongs_to :covering_team, class_name: "Team"
  has_one :generic_subscription, class_name: "Billing::Subscription", as: :provider_subscription

  after_create :create_generic_subscription

  def status=(new_status)
    generic_subscription.status = new_status
    generic_subscription.save
  end

  def create_generic_subscription
    Billing::Subscription.create!({
      team: self.team,
      provider_subscription: self,
      status: "active"
    })
  end

  def valid_teams
    # TODO: We probably only want teams for which the current user is an admin
    Current.user&.teams&.where&.not(id: Current.team&.id) || Team.none
  end
end
