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
    params.require(:billing_umbrella_subscription).permit(:covering_team_id, :status)
  end
end
