module BulletTrain::Billing::UmbrellaSubscriptions::TeamMonkeyPatch
  extend ActiveSupport::Concern
  prepended do
    has_many :billing_umbrella_subscriptions, class_name: "Billing::Umbrella::Subscription", dependent: :destroy, foreign_key: :team_id
    has_many :billing_covering_subscriptions, class_name: "Billing::Umbrella::Subscription", dependent: :destroy, foreign_key: :covering_team_id

    def active_covering_subscriptions
      billing_covering_subscriptions.joins(:generic_subscription).where("billing_subscriptions.status" => "active")
    end

    def umbrella_subscription_cover_limt_reached?
      # First we have to check our recurssion bailout condition
      if current_billing_subscription && current_billing_subscription.provider_subscription_type == "Billing::Umbrella::Subscription"
        return true
      end
      limiter = Billing::Limiter.new(self)
      # TODO: This assumes that the covering team has only one subscription, because we seem to assume that BT teams
      # only have one subscription. If that changes this will need to be tweaked.
      limits = limiter.current_products.first.limits
      if limits["billing/umbrella/subscriptions"]
        cover_limit = limits["billing/umbrella/subscriptions"]["cover"]["count"]
        if active_covering_subscriptions.count < cover_limit
          return false
        end
      end
      true
    end

    def can_extend_umbrella_subscriptions?
      # First we have to check our recurssion bailout condition
      if current_billing_subscription && current_billing_subscription.provider_subscription_type == "Billing::Umbrella::Subscription"
        return false
      end
      limiter = Billing::Limiter.new(self)
      # TODO: This assumes that the covering team has only one subscription, because we seem to assume that BT teams
      # only have one subscription. If that changes this will need to be tweaked.
      limits = limiter.current_products.first.limits
      if limits["billing/umbrella/subscriptions"]
        cover_limit = limits["billing/umbrella/subscriptions"]["cover"]["count"]
        if cover_limit > 0
          return true
        end
      end
      false
    end
  end
end
