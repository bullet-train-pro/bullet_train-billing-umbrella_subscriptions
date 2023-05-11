# frozen_string_literal: true

require_relative "lib/bullet_train/billing/umbrella_subscriptions/version"

Gem::Specification.new do |spec|
  spec.name = "bullet_train-billing-umbrella_subscriptions"
  spec.version = BulletTrain::Billing::UmbrellaSubscriptions::VERSION
  spec.authors = ["Jeremy Green"]
  spec.email = ["jeremy@octolabs.com"]

  spec.summary = "An extension to the billing module that allows you to extend a subscription to cover multiple teams"
  spec.description = "An extension to the billing module that allows you to extend a subscription to cover multiple teams"
  spec.homepage = "https://github.com/bullet-train-co/bullet_train-billing-umbrella_subscriptions"
  spec.required_ruby_version = ">= 2.6.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 6.0"
  spec.add_dependency "bullet_train"
  spec.add_dependency "bullet_train-billing"
  spec.add_dependency "bullet_train-billing-usage"
  spec.add_dependency "verbs"

  spec.add_development_dependency "pg", "~> 1.4.5"
  spec.add_development_dependency "factory_bot_rails", "~> 6.2.0"
  spec.add_development_dependency "standard"
end
