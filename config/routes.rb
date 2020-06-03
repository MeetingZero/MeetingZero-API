Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          post "/login" => "users#login"
          get "/me" => "users#me"
        end
      end
    end
  end
end
