require 'spec_helper'

describe "Payment pages" do

  subject { page }

	describe "billing page" do
		describe "for signed in user" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				sign_in user
				visit payments_path
			end

			it { should have_selector('h1',    text: 'Manage Payment Options') }
			it { should have_selector('title', text: full_title('Billing')) }
			it { should have_content('You do not have any recorded payment instruments.') }
		end

		describe "for user not signed in" do
			before do
				visit payments_path
			end

			it { should have_content('You need to sign in or sign up before continuing.') }
		end

		describe "for signed in user with payment" do
			let(:user) { FactoryGirl.create(:user) }
			let!(:payment) { FactoryGirl.create(:payment, user: user) }
			before do
				sign_in user
				visit payments_path
			end

			it { should have_link('edit', href: edit_payment_path(payment)) }
			it { should have_link('delete', href: payment_path(payment)) }
		end
	end

	describe "create" do
		let(:user) { FactoryGirl.create(:user) }
		let(:submit) { "Submit" }
		before do
			sign_in user
			visit new_payment_path 
		end

		it { should have_content("Address Line 1")}
		it { should have_content("Address Line 2")}
		it { should have_content("State")}
		it { should have_content("Zip code")}

		describe "with invalid information" do
			it "should not create a payment method" do
				expect { click_button submit }.not_to change(Payment, :count)
			end

			describe "error messages" do
				before { click_button submit }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			before do
				fill_in "payment_billing_address_1",	with: "123 Example Street"
				fill_in "payment_billing_state",		with: "OR"
				fill_in "payment_billing_zip_code",		with: 97777
			end

			it "should create a payment" do
				expect { click_button submit }.to change(Address, :count).by(1)
			end

			describe "after saving the payment" do
				before { click_button submit }
				it { should have_content("123 Example Street") }
				it { should have_content("OR") } 
				it { should have_content("97777") } 
				it { should have_selector('div.alert.alert-success', text: 'Payment method added!') }
			end
		end
	end

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		let(:payment) { FactoryGirl.create(:payment) }
		before do
			sign_in user
			visit edit_payment_path(payment)
		end

		it { should have_content("Address Line 1")}
		it { should have_content("Address Line 2")}
		it { should have_content("State")}
		it { should have_content("Zip code")}

		describe "with valid information" do
			let(:new_payment)  { "12345 Test Street" }
			let(:new_state)  { "EZ" }
			let(:new_zip_code)  { 99888 }
			before do
				fill_in "payment_billing_address_1",	with: new_payment
				fill_in "payment_billing_state",		with: new_state
				fill_in "payment_billing_zip_code",		with: new_zip_code
				click_button "Submit"
			end

			it { should have_selector('div.alert.alert-success') }
			specify { payment.reload.state.should  == new_state }
		end
	end
end