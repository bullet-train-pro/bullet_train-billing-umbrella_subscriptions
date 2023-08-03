require "bullet_train/billing/umbrella_subscriptions/version"
require "bullet_train/billing/umbrella_subscriptions/engine"

require "bullet_train/billing"
require "bullet_train/billing/usage"

require "bullet_train/billing/umbrella_subscriptions/team_monkey_patch"
require "bullet_train/billing/usage/product_catalog_monkey_patch"

module BulletTrain
  module Billing
    module UmbrellaSubscriptions
      class Error < StandardError; end

      module AbilitySupport
        extend ActiveSupport::Concern

        def apply_billing_abilities(user)
          super
          can :read, ::Billing::Umbrella::Subscription, team_id: user.team_ids
          can :manage, ::Billing::Umbrella::Subscription, team_id: user.administrating_team_ids
        end
      end
    end
  end
end

ActiveSupport.on_load(:bullet_train_billing_ability_support) { prepend BulletTrain::Billing::UmbrellaSubscriptions::AbilitySupport }
