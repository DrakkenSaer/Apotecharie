Apotecharie::Application.routes.draw do

  mount Spree::Core::Engine, :at => '/'

  Spree::Core::Engine.routes.draw do
    match '/contact',  	to: 'home#contact'
    match '/about',    	to: 'home#about'
    match '/help',     	to: 'home#help'
    match '/users/:id',	to: 'users#show'
    resources :headlines, only: [:show, :index]

  	namespace :admin do
  		resources :headlines do
        collection do
          get :search
        end
      end
  	end
  end
  
end
