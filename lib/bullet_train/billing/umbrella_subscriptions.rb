require "bullet_train/billing/umbrella_subscriptions/version"
require "bullet_train/billing/umbrella_subscriptions/engine"

require "bullet_train/billing"
require "bullet_train/billing/usage"

require "bullet_train/billing/usage/product_catalog_monkey_patch"

module BulletTrain
  module Billing
    module UmbrellaSubscriptions
      class Error < StandardError; end
      # Your code goes here...
    end
  end
end
