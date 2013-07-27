Apotecharie::Application.routes.draw do

  mount Spree::Core::Engine, :at => '/'

  Spree::Core::Engine.routes.draw do
    match '/contact',  	to: 'home#contact'
    match '/about',    	to: 'home#about'
    match '/help',     	to: 'home#help'
    match '/users/:id',	to: 'users#show'
    resources :headlines, only: [:index]

    devise_scope :spree_user do
      match '/forgot',   to: 'user_passwords#new', method: :get
      match '/password', to: 'user_passwords#create', method: :post
      match '/sign_in',  to: 'user_sessions#create', method: :post
      match '/new_user', to: 'user_registrations#create', method: :post 
    end

  	namespace :admin do
  		resources :headlines do
        collection do
          get :search
        end
      end
  	end
  end
end
