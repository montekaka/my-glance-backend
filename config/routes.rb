Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: 'api' do
    namespace :v1 do
      get 'public_profiles/:id' => 'public_profiles#show'
      get 'twitter_sign_in_link' => 'twitter_oauths#get_login_link'      
      post 'twitter_sign_in' => 'twitter_oauths#sign_in'
      post 'delete_oauth_token_session' => 'oauth_token_sessions#delete_sessions'

      resources :profiles do
        resources :social_networks
        post 'sync_social_networks' => 'social_networks#sync'

        resources :tech_skills
        post 'sync_tech_skills' => 'tech_skills#sync'

        resources :widgets
        post 'sync_widgets' => 'widgets#sync'
      end
    end
  end
end
