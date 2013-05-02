FactoryGirl.define do

	factory :user do

 		sequence(:email) { |n| "person_#{n}@example.com" } 
		password "foobar666"
		password_confirmation "foobar666"

		factory :admin do
			admin true
		end
	end	

	factory :address do
		address_1 "2345 Example Street"
		address_2 "Suite #6"
		state "EX"
		zip_code 97979
		user
	end

	factory :payment do
		billing_address_1 "2345 Example Street"
		billing_address_2 "Suite #6"
		billing_state "EX"
		billing_zip_code 97979
		user
	end

	factory :product do
		sequence(:title) { |n| "Example Title #{n}"}
		sequence(:description) { |n| "Example description #{n}" }
		price 5.99
		shipping_price 6.66
		image File.new(Rails.root + 'spec/fixtures/images/rails.png')
	end

	factory :headline do
		title "Test Title"
		body  "test content test content test content test content"
	end
end