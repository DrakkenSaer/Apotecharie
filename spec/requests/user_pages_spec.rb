require 'spec_helper'

describe "User pages" do

  subject { page }

	describe "edit" do
		let!(:user) { FactoryGirl.create(:user, email: "ben@example.com") }

		describe "as normal user" do
			before do
				sign_in user
				visit edit_user_registration_path
			end

			describe "viewing the admin edit page" do
				before do
					visit edit_user_path(user)
				end
				it { should have_content("You do not have sufficient privileges to view this page!") }
			end

			describe "viewing the page" do
				before {visit edit_user_registration_path}
				it {should have_selector('h2', text: "Settings for " + user.email)}
				it {should have_selector('label', text: "Email")}
				it {should have_selector('label', text: "Password")}
				it {should have_selector('label', text: "Password confirmation")}
				it {should have_selector('label', text: "Current password")}
			end

			describe "with valid information" do
				let(:new_email)		{ "new@example.com" }
				let(:new_password)	{ "differentpass" }
				before do
					fill_in "Email",					with: new_email
					fill_in "Password",					with: new_password
					fill_in "Password confirmation",	with: new_password
					fill_in "Current password",         with: user.password
					click_button "Update"
				end
			
				it { should have_content("Changes were successfully saved!") }
				it { should have_link('Sign out', href: signout_path) }
				specify { user.reload.email.should  == new_email }
			end
		end

		describe "as administrator" do
			let(:admin) { FactoryGirl.create(:admin) }
			before do
				sign_in admin
				visit edit_user_path(user)
			end

			describe "viewing the page" do
				before {visit edit_user_path(user)}
				it {should have_selector('h2', text: "Settings for " + user.email)}
				it {should have_selector('label', text: "Email")}
				it {should have_selector('label', text: "Password")}
				it {should have_selector('label', text: "Password confirmation")}
			end

			describe "with valid information" do
				let(:new_email)		{ "new@example.com" }
				let(:new_password)	{ "differentpass" }
				before do
					fill_in "Email",					with: new_email
					fill_in "Password",					with: new_password
					fill_in "Password confirmation",	with: new_password
					click_button "Update"
				end
			
				it { should have_selector('title', text: "All users") }
				it { should have_selector('div.alert.alert-success') }
				it { should have_link('Sign out', href: signout_path) }
				specify { user.reload.email.should  == new_email }
			end
		end
	end

	describe "signup page" do
		before do 
			visit signup_path 
		end

		it { should have_selector('h2',    text: 'Sign up') }
		it { should have_selector('title', text: full_title('Sign up')) }
	end

	describe "signup" do
		let(:submit) { "Sign up" }
		before do
			visit signup_path
		end

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "error messages" do
				before { click_button submit }

				it { should have_selector('title', text: 'Sign up') }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			before do
				fill_in 'user_email',        with: "user@example.com"
				fill_in 'user_password',     with: "testing1"
				fill_in 'user_password_confirmation', with: "testing1"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before { click_button submit }

				let(:user) { User.find_by_email('user@example.com') }

				it { should have_content('Welcome! You have signed up successfully.') }
				it { should have_link('Sign out') }
			end
		end
	end

	describe "signin page" do
		before { visit signin_path }

		it { should have_selector('h2',    text: 'Sign in') }
		it { should have_selector('title', text: full_title('Sign in')) }
	end

	describe "index" do
		describe "for admins" do
			let(:admin) { FactoryGirl.create(:admin) }
			before do
				FactoryGirl.create(:user, email: "bob@example.com")
				FactoryGirl.create(:user, email: "ben@example.com")
				sign_in admin
				visit users_path
			end

			it { should have_selector('title', text: 'All users') }

			describe "pagination" do

				before(:all) { 30.times { FactoryGirl.create(:user) } }
				after(:all)  { User.delete_all }

				let(:first_page)  { User.paginate(page: 1) }
				let(:second_page) { User.paginate(page: 2) }

				it { should have_link('Next') }
				its(:html) { should match('>2</a>') }

				it "should list each user" do
					User.all[0..2].each do |user|
						page.should have_selector('li', text: user.email)
					end
				end

				it "should list the first page of users" do
					first_page.each do |user|
						page.should have_selector('li', text: user.email)
					end
				end

				it "should not list the second page of users" do
					second_page.each do |user|
						page.should_not have_selector('li', text: user.email)
					end
				end

				describe "showing the second page" do
					before { visit users_path(page: 2) }

					it "should list the second page of users" do
						second_page.each do |user|
							page.should have_selector('li', text: user.email)
						end
					end
				end 
			end

			describe "delete links for admins" do

				it { should have_link('edit', href: edit_user_path(User.first)) }
				it { should have_link('delete', href: user_path(User.first)) }
				it "should be able to delete another user" do
					expect { click_link('delete') }.to change(User, :count).by(-1)
				end
				it { should_not have_link('delete', href: edit_user_path(admin)) }
				it { should_not have_link('edit', href: user_path(admin)) }
			end
		end

		describe "for normal users" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				FactoryGirl.create(:user, email: "bob@example.com")
				FactoryGirl.create(:user, email: "ben@example.com")
				sign_in user
				visit users_path
			end

			it { should_not have_link('edit', href: edit_user_path(User.first)) }
			it { should_not have_link('delete', href: user_path(User.first)) }
		end
	end

	describe "profile page" do
		let(:user){FactoryGirl.create(:user)}
		before do 
			sign_in user
			visit user_path(user) 
		end

		it { should have_selector('h1',    text: user.email) }
		it { should have_selector('title', text: user.email) }
	end

end