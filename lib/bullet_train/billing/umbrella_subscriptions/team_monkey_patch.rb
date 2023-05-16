module BulletTrain::Billing::UmbrellaSubscriptions::TeamMonkeyPatch
  extend ActiveSupport::Concern
  prepended do
    has_many :billing_umbrella_subscriptions, class_name: "Billing::Umbrella::Subscription", dependent: :destroy, foreign_key: :team_id
  end
end
