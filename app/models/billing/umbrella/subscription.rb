class Billing::Umbrella::Subscription < ApplicationRecord
  belongs_to :team
  belongs_to :covering_team, class_name: "Team"
  has_one :generic_subscription, class_name: "Billing::Subscription", as: :provider_subscription

  validate :covering_team_cover_limit, on: :create

  after_create :create_generic_subscription

  def status=(new_status)
    generic_subscription.status = new_status
    generic_subscription.save
  end

  def create_generic_subscription
    Billing::Subscription.create!({
      team: team,
      provider_subscription: self,
      status: "active"
    })
  end

  def valid_covering_teams
    # TODO: This is kinda messy, but does what we need. Ideally we wouldn't hard code the admin role here.
    # And ideally we could do all of this as one big select, but my SQL foo is weak.

    # an array to hold the IDs of teams that we consider valid
    valid_team_ids = []

    # First grab all the memberships for which the current user has the admin role
    memberships = Current.user.memberships.where("role_ids ?& array[:keys]", keys: ["admin"])

    # Now loop the memberships, and if the team has not reached the cover limit add the id to the array
    memberships.each do |membership|
      if !membership.team.umbrella_subscription_cover_limt_reached?
        valid_team_ids.push membership.team.id
      end
    end

    Team.where(id: valid_team_ids)
  end

  def valid_covered_teams
    # TODO: This is kinda messy, but does what we need. Ideally we wouldn't hard code the admin role here.
    # And ideally we could do all of this as one big select, but my SQL foo is weak.

    # an array to hold the IDs of teams that we consider valid
    valid_team_ids = []

    # First grab all the memberships for which the current user has the admin role
    memberships = Current.user.memberships.where("role_ids ?& array[:keys]", keys: ["admin"])

    # Now loop the memberships, and if the team does not have an active subscription of some kind
    memberships.each do |membership|
      if !membership.team.current_billing_subscription
        valid_team_ids.push membership.team.id
      end
    end

    Team.where(id: valid_team_ids)
  end

  def covering_team_cover_limit
    if covering_team.umbrella_subscription_cover_limt_reached?
      errors.add(:base, "The team you selected is not allowed to cover any additional teams.")
    end
  end
end
