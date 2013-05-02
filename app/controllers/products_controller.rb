class ProductsController < ApplicationController
	before_filter :authenticate_user!, except: [:index, :show]
	before_filter :admin_user, except: [:index, :show]

	def new
		@product = Product.new
	end

	def create
		@product = Product.create(params[:product])
		if @product.save
			flash[:success] = "New product created!"
			redirect_to products_path
			else
			render 'new'
		end
	end

	def index
		@products = Product.paginate(page: params[:page])
	end

	def show
		@product = Product.find(params[:id])
	end

	def edit
		@product = Product.find(params[:id])
	end

	def update
		@product = Product.find(params[:id])
		if @product.update_attributes(params[:product])
			flash[:success] = "Product listing updated!"
			redirect_to products_path
			else
			render 'new'
		end
	end

	def destroy
		Product.find(params[:id]).destroy
		flash[:success] = "Product listing removed."
		redirect_to products_url
	end

	private

		def admin_user
	      unless current_user.admin?
	        redirect_to current_user, notice: "You do not have sufficient privileges to view this page!"
	      end
	    end

end
