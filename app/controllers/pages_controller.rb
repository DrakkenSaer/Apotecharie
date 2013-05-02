class PagesController < ApplicationController
	before_filter :authenticate_user!,	only: [:admin]
	before_filter :admin_user,			only: [:admin]

	def home
	end

	def contact
	end

	def help
	end

	def about
	end

	def admin
	end

	private
		def admin_user
		  unless current_user.admin?
		    redirect_to current_user, notice: "You do not have sufficient privileges to view this page!"
		  end
		end

end
