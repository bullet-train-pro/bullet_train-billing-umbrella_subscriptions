class BulletTrain::Billing::UmbrellaSubscriptions::SystemTestGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def copy_test_file
    copy_file "umbrella_subscriptions_test.rb", "test/system/umbrella_subscriptions_test.rb"
  end
end
