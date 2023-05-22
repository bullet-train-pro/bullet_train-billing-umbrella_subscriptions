require "test_helper"
require "generators/bullet_train/billing/umbrella_subscriptions/system_test/system_test_generator"

class BulletTrain::Billing::UmbrellaSubscriptions::SystemTestGeneratorTest < Rails::Generators::TestCase
  tests BulletTrain::Billing::UmbrellaSubscriptions::SystemTestGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
