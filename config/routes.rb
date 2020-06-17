Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          post "/login" => "users#login"
          get "/me" => "users#me"
          post "/forgot-password" => "users#forgot_password"
          post "/reset-password" => "users#reset_password"
        end
      end

      resources :workshops do
        resources :director, controller: :workshop_directors do
          collection do
            get "/current" => "workshop_directors#current"
          end
        end
      end
    end
  end

  resources :users, only: [] do
    collection do
      get "/activate-account" => "users#activate_account"
    end
  end
end
