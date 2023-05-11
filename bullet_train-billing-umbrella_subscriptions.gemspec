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

  #spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 6.0"
  spec.add_dependency "bullet_train"
  spec.add_dependency "verbs"

  spec.add_development_dependency "pg", "~> 1.4.5"
  spec.add_development_dependency "factory_bot_rails", "~> 6.2.0"
  spec.add_development_dependency "standard"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
