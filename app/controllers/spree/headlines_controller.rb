module Spree
  class HeadlinesController < Spree::StoreController

    def index
    	@headlines = Headline.where(deleted_at: nil).order(:created_at).page params[:page]
    end
  end
end