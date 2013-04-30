class UsersController < ApplicationController
	before_filter :authenticate_user!, only: [:show, :edit, :update, :index, :destroy]
	before_filter :correct_user,   only: [:show, :edit, :update, :destroy]
	before_filter :admin_user,     only: [:destroy]

	def index
		@users = User.paginate(page: params[:page])
	end

	def show
		@user = User.find(params[:id])
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed."
		redirect_to users_url
	end

	private

		def current_user?(user)
	  		user == current_user
	  	end
		
		def correct_user
			@user = User.find(params[:id])
			redirect_to(current_user) unless current_user?(@user) or current_user.admin?
		end

		def admin_user
	      unless current_user.admin?
	        redirect_to current_user, notice: "You do not have sufficient privileges to view this page!"
	      end
	    end

end
