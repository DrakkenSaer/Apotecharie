class Address < ActiveRecord::Base
	attr_accessible :address_1, :address_2, :state, :zip_code

	belongs_to :user
	
	[:address_1, :state, :zip_code, :user_id].each do |n|

		validates n, presence: true

	end
end