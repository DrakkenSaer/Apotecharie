module Spree
  class HeadlinesController < Spree::StoreController

    def index
    	@headlines = Headline.order(:created_at).page params[:page]
    end

    def show
        @headline = Headline.find(params[:id])
    end
  end
end
