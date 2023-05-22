module BulletTrain::Billing::UmbrellaSubscriptions::Testing
  extend ActiveSupport::Concern

  included do
  end

  def setup
    super
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
    @team = @jane.teams.first
    @other_team = @jane.teams.where.not(id: @team.id).first || create(:team, name: "Other Team")
    create :membership, user: @jane, team: @other_team, role_ids: [Role.admin.id]

    provider_subscription = Billing::External::Subscription.create!(team: @team)

    subscription = Billing::Subscription.create!({
      team: @team,
      provider_subscription: provider_subscription,
      status: "active"
    })

    Billing::Subscriptions::IncludedPrice.create!(
      subscription: subscription,
      price_id: "pro_monthly_2023",
      quantity: 1
    )
  end

  def default_umbrella_subscriptions_push_test(device_name, display_details)
    resize_for(display_details)
    login_as(@jane, scope: :user)
    @jane.current_team = @team

    visit root_path

    # TODO: This is a little bit low-level for a system test but for now it's a sanity check.
    # This should really probably be testsed somewhere else.
    limiter = Billing::Limiter.new(@other_team)
    assert_equal "free", limiter.current_products.first.id

    assert page.has_content?("Teams")

    # within_team_menu_for_team(@jane.current_team) do
    within_team_menu_for(display_details) do
      click_link "Billing"
    end
    assert page.has_content?("Subscriptions")

    pp Team.all.as_json
    puts "-" * 90
    pp Billing::Subscription.all.as_json
    puts "-" * 90

    assert page.has_content?("Umbrella Subscriptions")

    click_on "Add New Umbrella Subscription"
    assert page.has_content?("New Umbrella Subscription Details")

    click_on "Create Umbrella Subscription"
    assert page.has_content?("Umbrella Subscription was successfully created")

    # TODO: This is a little bit low-level for a system test but for now it's a sanity check.
    # This should really probably be testsed somewhere else.
    limiter = Billing::Limiter.new(@other_team)
    assert_equal "pro", limiter.current_products.first.id

    click_on "Edit"
    assert page.has_content?("Umbrella Subscription Details")

    click_on "Cancel this Umbrella Subscription"
    assert page.has_content?("Umbrella Subscription was successfully updated")

    # TODO: This is a little bit low-level for a system test but for now it's a sanity check.
    # This should really probably be testsed somewhere else.
    limiter = Billing::Limiter.new(@other_team)
    assert_equal "free", limiter.current_products.first.id
  end

  def default_umbrella_subscriptions_pull_test(device_name, display_details)
    resize_for(display_details)
    login_as(@jane, scope: :user)
    @jane.current_team = @other_team

    visit root_path

    # TODO: This is a little bit low-level for a system test but for now it's a sanity check.
    # This should really probably be testsed somewhere else.
    limiter = Billing::Limiter.new(@other_team)
    assert_equal "free", limiter.current_products.first.id

    assert page.has_content?("Teams")

    # within_team_menu_for_team(@jane.current_team) do
    within_team_menu_for(display_details) do
      click_link "Billing"
    end
    assert page.has_content?("Upgrade")

    click_on "Upgrade"
    assert page.has_content?("You may be able to cover your team")

    click_on "Click here to learn more."
    assert page.has_content?("New Umbrella Subscription Details")

    click_on "Create Umbrella Subscription"
    assert page.has_content?("Umbrella Subscription was successfully created")

    # TODO: This is a little bit low-level for a system test but for now it's a sanity check.
    # This should really probably be testsed somewhere else.
    limiter = Billing::Limiter.new(@other_team)
    assert_equal "pro", limiter.current_products.first.id

    click_on "Manage"
    assert page.has_content?("Umbrella Subscription Details")

    click_on "Cancel this Umbrella Subscription"
    assert page.has_content?("Umbrella Subscription was successfully updated")

    # TODO: This is a little bit low-level for a system test but for now it's a sanity check.
    # This should really probably be testsed somewhere else.
    limiter = Billing::Limiter.new(@other_team)
    assert_equal "free", limiter.current_products.first.id
  end
end
