OauthProviderDemo::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'registrations',
                                       :sessions => 'sessions'}

  # omniauth client stuff
  match '/auth/:provider/callback', :to => 'authentications#create', :via => [:get, :post]
  match '/auth/failure', :to => 'authentications#failure', :via => [:get, :post]

  # Provider stuff
  match '/auth/josh_id/authorize' => 'auth#authorize', :via => [:get, :post]
  match '/auth/josh_id/access_token' => 'auth#access_token', :via => [:get, :post]
  match '/auth/josh_id/user' => 'auth#user', :via => [:get, :post]
  match '/oauth/token' => 'auth#access_token', :via => [:get, :post]

  # Account linking
  match 'authentications/:user_id/link' => 'authentications#link', :as => :link_accounts, :via => [:get, :post]
  patch 'authentications/:user_id/add' => 'authentications#add', :as => :add_account

  root :to => 'auth#welcome'
end
