class Payment < ActiveRecord::Base
	attr_accessible :billing_address_1, :billing_address_2, 
					:billing_state, :billing_zip_code

	belongs_to :user
	
	[:billing_address_1, :billing_state, :billing_zip_code,
	 :user_id].each do |n|

		validates n, presence: true

	end
end
