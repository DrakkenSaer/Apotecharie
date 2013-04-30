require 'spec_helper'

describe "Address pages" do

  subject { page }

	describe "index page" do
		describe "for signed in user with no address" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				sign_in user
				visit addresses_path
			end

			it { should have_selector('h1',    text: 'Manage Shipping Address') }
			it { should have_selector('title', text: full_title('Address')) }
			it { should have_content("We don't have a recorded shipping address for you.") }
		end

		describe "for user not signed in" do
			before do
				visit addresses_path
			end

			it { should have_content('You need to sign in or sign up before continuing.') }
		end

		describe "for signed in user with address" do
			let(:user) { FactoryGirl.create(:user) }
			let!(:address) { FactoryGirl.create(:address, user: user) }
			before do
				sign_in user
				visit addresses_path
			end

			it { should have_link('edit', href: edit_address_path(address)) }
			it { should have_link('delete', href: address_path(address)) }
		end
	end

	describe "create" do
		let(:user) { FactoryGirl.create(:user) }
		let(:submit) { "Submit" }
		before do
			sign_in user
			visit new_address_path 
		end

		it { should have_content("Address Line 1")}
		it { should have_content("Address Line 2")}
		it { should have_content("State")}
		it { should have_content("Zip code")}

		describe "with invalid information" do
			it "should not create an address" do
				expect { click_button submit }.not_to change(Address, :count)
			end

			describe "error messages" do
				before { click_button submit }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			before do
				fill_in "address_address_1",	with: "123 Example Street"
				fill_in "address_state",		with: "OR"
				fill_in "address_zip_code",		with: 97777
			end

			it "should create a address" do
				expect { click_button submit }.to change(Address, :count).by(1)
			end

			describe "after saving the address" do
				before { click_button submit }
				it { should have_content("123 Example Street") }
				it { should have_content("OR") } 
				it { should have_content("97777") } 
				it { should have_selector('div.alert.alert-success', text: 'Shipping address added!') }
			end
		end

		describe "trying to add address when one exists" do
			before do
				FactoryGirl.create(:address, user: user)
				visit new_address_path 
			end
			it { should have_selector('div.alert.alert-error', text: 'You already have an address on file!') }
		end
	end

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		let(:address) { FactoryGirl.create(:address) }
		before do
			sign_in user
			visit edit_address_path(address)
		end

		it { should have_content("Address Line 1")}
		it { should have_content("Address Line 2")}
		it { should have_content("State")}
		it { should have_content("Zip code")}

		describe "with valid information" do
			let(:new_address)  { "12345 Test Street" }
			let(:new_state)  { "EZ" }
			let(:new_zip_code)  { 99888 }
			before do
				fill_in "address_address_1",	with: new_address
				fill_in "address_state",		with: new_state
				fill_in "address_zip_code",		with: new_zip_code
				click_button "Submit"
			end

			it { should have_selector('div.alert.alert-success') }
			specify { address.reload.state.should  == new_state }
		end
	end
end