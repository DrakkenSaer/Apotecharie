module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
    end

    def about
    end

    def help
    end

    def contact
    end
  end
end
