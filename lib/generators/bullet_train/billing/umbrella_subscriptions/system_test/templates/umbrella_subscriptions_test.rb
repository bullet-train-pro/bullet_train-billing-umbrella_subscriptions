require "application_system_test_case"
require "bullet_train/billing/umbrella_subscriptions/testing"

class UmbrellaSubscriptionsTest < ApplicationSystemTestCase
  include BulletTrain::Billing::UmbrellaSubscriptions::Testing

  @@test_devices.each do |device_name, display_details|
    test "default umbrella subscirptions push test on a #{device_name}" do
      default_umbrella_subscriptions_push_test(device_name, display_details)
    end

    test "default umbrella subscirptions pull test on a #{device_name}" do
      default_umbrella_subscriptions_pull_test(device_name, display_details)
    end
  end
end
