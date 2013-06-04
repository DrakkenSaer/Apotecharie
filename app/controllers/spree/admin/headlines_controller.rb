module Spree
  module Admin
    class HeadlinesController < ResourceController

      before_filter :check_json_authenticity, :only => :index

      def index
        session[:return_to] = request.url
        respond_with(@collection)
      end

      def search
        if params[:ids]
          @headlines = Spree::Headline.where(:id => params[:ids].split(","))
        else
          search_params = { :title_cont => params[:q], :poster_cont => params[:q] }
          @headlines = Spree::Headline.ransack(search_params.merge(:m => 'or')).result
        end
      end

      def update
        super
      end

      def destroy
        @headline = Spree::Headline.find(params[:id])
        @headline.delete

        flash.notice = I18n.t('notice_messages.headline_deleted')

        respond_with(@headline) do |format|
          format.html { redirect_to collection_url }
          format.js  { render_js_for_destroy }
        end
      end

      protected

        def find_resource
          Spree::Headline.find(params[:id])
        end

        def location_after_save
          edit_admin_headline_url(@headline)
        end

        def collection
          return @collection if @collection.present?
          params[:q] ||= {}
          params[:q][:deleted_at_null] ||= "1"

          params[:q][:s] ||= "name asc"

          @search = super.ransack(params[:q])
          @collection = @search.result.
            page(params[:page]).
            per(25)

          @collection
        end

    end
  end
end