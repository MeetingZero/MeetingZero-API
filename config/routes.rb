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
        get "/members" => "workshops#members"
        put "/start" => "workshops#start_workshop"
        get "/validate" => "workshops#validate"
        put "/complete-step" => "workshops#complete_step"

        resources :director, controller: :workshop_directors do
          collection do
            get "/current" => "workshop_directors#current"
          end
        end

        resources :what_is_working

        resources :problems

        resources :reframe_problem

        resources :opportunity_question

        resources :solutions do
          put "/prioritize" => "solutions#prioritize"
        end

        resources :star_voting_votes do
          collection do
            post "/calculate-votes" => "star_voting_votes#calculate_votes"
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
