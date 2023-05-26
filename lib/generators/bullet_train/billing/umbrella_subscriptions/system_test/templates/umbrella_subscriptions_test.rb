require "application_system_test_case"
require "bullet_train/billing/umbrella_subscriptions/testing"

class UmbrellaSubscriptionsTest < ApplicationSystemTestCase
  include BulletTrain::Billing::UmbrellaSubscriptions::Testing

  def setup
    # You should make sure that these match producs that you have defined in config/models/products.yml.
    # The pro level product needs to have umbrella subscriptions configured.
    @pro_level_product_name = "pro"
    @pro_level_price_id = "pro_monthly_2023"
    @basic_level_product_name ||= "basic"
    @basic_level_price_id ||= "basic_monthly_2023"
    @free_level_product_name = "free"

    super
  end

  @@test_devices.each do |device_name, display_details|
    test "default umbrella subscirptions push test on a #{device_name}" do
      default_umbrella_subscriptions_push_test(device_name, display_details)
    end

    test "default umbrella subscirptions pull test on a #{device_name}" do
      default_umbrella_subscriptions_pull_test(device_name, display_details)
    end
  end
end
