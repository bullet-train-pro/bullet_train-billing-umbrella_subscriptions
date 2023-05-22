Rails.application.routes.draw do
  namespace :account do
    shallow do
      resources :teams, only: [] do
        namespace :billing do
          namespace :umbrella do
            resources :subscriptions
          end
          resources :subscriptions, only: [] do
            namespace :umbrella do
              resources :subscriptions
            end
          end
        end
      end
    end
  end
end
