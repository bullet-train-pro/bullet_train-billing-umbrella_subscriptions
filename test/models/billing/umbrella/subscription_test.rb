require "test_helper"

class Billing::Umbrella::SubscriptionTest < ActiveSupport::TestCase
  # Just a starter test to make sure the class is coming up
  test "you can new up an umbrella subscription" do
    umbrella_subscription = Billing::Umbrella::Subscription.new
    assert umbrella_subscription
  end

end
