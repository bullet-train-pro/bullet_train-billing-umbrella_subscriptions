module BulletTrain
  module Billing
    module UmbrellaSubscriptions
      class Engine < ::Rails::Engine
        config.to_prepare do
          ::Billing::Usage::ProductCatalog.prepend(BulletTrain::Billing::Usage::ProductCatalogMonkeyPatch)
        end
      end
    end
  end
end
