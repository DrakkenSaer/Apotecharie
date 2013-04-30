class AddressesController < ApplicationController
	before_filter :authenticate_user!
	before_filter :taken, only: [:new, :create]

	def index
		@addresses = current_user.addresses
	end

	def new
		@address = Address.new
	end

	def create
		@address = current_user.addresses.build(params[:address])
		if @address.save
			flash[:success] = "Shipping address added!"
			redirect_to addresses_path
			else
			render 'new'
		end
	end

	def show
		redirect_to addresses_path
	end

	def edit
		@address = Address.find(params[:id])
	end

	def update
		@address = Address.find(params[:id])
		if @address.update_attributes(params[:address])
			flash[:success] = "Shipping address updated!"
			redirect_to addresses_path
			else
			render 'new'
		end
	end

	def destroy
		Address.find(params[:id]).destroy
		flash[:success] = "Address removed."
		redirect_to addresses_url
	end

	private

	def taken
		unless current_user.addresses.empty?
			redirect_to addresses_path 
			flash[:error] = "You already have an address on file!"
		end
	end

end
