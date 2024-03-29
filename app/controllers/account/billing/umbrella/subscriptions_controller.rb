class Account::Billing::Umbrella::SubscriptionsController < Account::ApplicationController
  account_load_and_authorize_resource :subscription, through: :team, through_association: :billing_umbrella_subscriptions

  # GET /account/teams/:team_id/billing/umbrella/subscriptions
  # GET /account/teams/:team_id/billing/umbrella/subscriptions.json
  def index
  end

  # GET /account/billing/umbrella/subscriptions/:id
  # GET /account/billing/umbrella/subscriptions/:id.json
  def show
  end

  # GET /account/teams/:team_id/billing/umbrella/subscriptions/new
  def new
  end

  # GET /account/billing/umbrella/subscriptions/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/billing/umbrella/subscriptions
  # POST /account/teams/:team_id/billing/umbrella/subscriptions.json
  def create
    respond_to do |format|
      covered_team_id = subscription_params[:team_id]
      valid_team_ids = Billing::Umbrella::Subscription.new.valid_covered_teams.map(&:id)
      # TODO: There's probably a better way to do this, but this allows us to "push" an umbrella subscription to another team.
      # Maybe we can figure out how to define valid_covered_teams in a way that's hard to express via CanCanCan abilities.
      if valid_team_ids.include?(covered_team_id.to_i)
        @subscription.team_id = covered_team_id
      end
      if @subscription.save
        format.html { redirect_to [:account, current_team, :billing, :subscriptions], notice: I18n.t("billing/umbrella/subscriptions.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @subscription] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/billing/umbrella/subscriptions/:id
  # PATCH/PUT /account/billing/umbrella/subscriptions/:id.json
  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html { redirect_to [:account, current_team, :billing, :subscriptions], notice: I18n.t("billing/umbrella/subscriptions.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @subscription] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/billing/umbrella/subscriptions/:id
  # DELETE /account/billing/umbrella/subscriptions/:id.json
  def destroy
    @subscription.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :billing_umbrella_subscriptions], notice: I18n.t("billing/umbrella/subscriptions.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  def subscription_params
    params.require(:billing_umbrella_subscription).permit(:covering_team_id, :status, :team_id)
  end
end
