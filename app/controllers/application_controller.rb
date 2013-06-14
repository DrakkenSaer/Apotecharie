class ApplicationController < ActionController::Base
  helper 'spree/products'
  protect_from_forgery
end
