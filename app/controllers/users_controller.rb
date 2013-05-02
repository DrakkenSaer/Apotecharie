class UsersController < ApplicationController
	before_filter :authenticate_user!, except: [:new, :create]
	before_filter :correct_user, only: [:edit, :update, :destroy]
	before_filter :admin_user, only: [:edit, :update, :destroy]

	def index
		@users = User.paginate(page: params[:page])
	end

	def show
		@user = User.find(params[:id])
	end

	def edit
	end

	def update
		if @user.update_attributes(params[:user])
			flash[:success] = "Changes were successfully saved!"
			redirect_to users_path
		else
			render 'edit'
		end
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
