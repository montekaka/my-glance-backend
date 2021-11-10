Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: 'api' do
    namespace :v1 do
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
