module BulletTrain::Billing::Usage::ProductCatalogMonkeyPatch
  # We override this method so that we can resolve Umbrella Subscriptions differently
  def current_products
    products = parent.team.billing_subscriptions.active.where.not(provider_subscription_type: "Billing::Umbrella::Subscription").map(&:included_prices).flatten.map(&:price).map(&:product)
    umbrella_subscriptions = parent.team.billing_subscriptions.active.where(provider_subscription_type: "Billing::Umbrella::Subscription")
    umbrella_subscriptions.each do |us|
      covering_team = us.provider_subscription.covering_team
      if covering_team.can_extend_umbrella_subscriptions?
        products += covering_team.billing_subscriptions.active.where.not(provider_subscription_type: "Billing::Umbrella::Subscription").map(&:included_prices).flatten.map(&:price).map(&:product)
      end
    end
    products.any? ? products : free_products
  end
end
