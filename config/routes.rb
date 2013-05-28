Apotecharie::Application.routes.draw do

  mount Spree::Core::Engine, :at => '/'

  Spree::Core::Engine.routes.draw do
    match '/contact',  	to: 'home#contact'
    match '/about',    	to: 'home#about'
    match '/help',     	to: 'home#help'
    match '/news',     	to: 'home#news'
    match '/users/:id',	to: 'users#show'
  end
  
end
