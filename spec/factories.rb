Dir["#{File.dirname(__FILE__)}/factories/**/*.rb"].each do |f|
  factories =  File.expand_path(f)
  require factories
end

FactoryGirl.define do

	factory :user do
 		sequence(:email) { |n| "person_#{n}@example.com" } 
		password "foobar"
		password_confirmation "foobar"

		factory :admin do
			admin_user true
		end
	end

	factory :headline do
		title "Test Title"
		body  "test content test content test content test content"
	end
end