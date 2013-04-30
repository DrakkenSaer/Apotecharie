class PaymentsController < ApplicationController
	before_filter :authenticate_user!

	def index
		@payments = current_user.payments.paginate(page: params[:page])
	end

	def new
		@payment = Payment.new
	end

	def create
		@payment = current_user.payments.build(params[:payment])
		if @payment.save
			flash[:success] = "Payment method added!"
			redirect_to payments_path
			else
			render 'new'
		end
	end

	def show
		redirect_to payments_path
	end

	def edit
		@payment = Payment.find(params[:id])
	end

	def update
		@payment = Payment.find(params[:id])
		if @payment.update_attributes(params[:payment])
			flash[:success] = "Payment method updated!"
			redirect_to payments_path
			else
			render 'new'
		end
	end

	def destroy
		Payment.find(params[:id]).destroy
		flash[:success] = "Payment method removed."
		redirect_to payments_url
	end

end
