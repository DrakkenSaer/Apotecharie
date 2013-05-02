require 'spec_helper'

describe "Product Pages" do

  subject { page }

  	describe "edit" do
		let(:admin) { FactoryGirl.create(:admin) }
		let(:product) { FactoryGirl.create(:product) }
		before do
			sign_in admin
			visit edit_product_path(product)
		end

		it { should have_content("Title")}
		it { should have_content("Description")}
		it { should have_content("Price")}
		it { should have_content("Shipping price")}

		describe "with valid information" do
			let(:new_title)  { "Title" }
			let(:new_description)  { "Description" }
			let(:new_price)  { 9.99 }
			let(:new_shipping_price)  { 8.88 }
			before do
				fill_in "product_title",			with: new_title
				fill_in "product_description",		with: new_description
				fill_in "product_price",			with: new_price
				fill_in "product_shipping_price",	with: new_shipping_price
				click_button "Submit"
			end

			it { should have_selector('div.alert.alert-success') }
			specify { product.reload.title.should  == new_title }
		end
	end

  describe "index" do
		describe "for admins" do
			let(:admin) { FactoryGirl.create(:admin) }
			before do
				FactoryGirl.create(:product)
				sign_in admin
				visit products_path
			end

			it { should have_selector('title', text: 'Inventory') }

			describe "delete links for admins" do

				it { should have_link('edit', href: edit_product_path(Product.first)) }
				it { should have_link('delete', href: product_path(Product.first)) }
				it "should be able to delete product listing" do
					expect { click_link('delete') }.to change(Product, :count).by(-1)
				end
			end
		end

		describe "for normal users" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				FactoryGirl.create(:product)
				sign_in user
				visit products_path
			end

			it { should_not have_link('edit', href: edit_product_path(Product.first)) }
			it { should_not have_link('delete', href: product_path(Product.first)) }
		end
	end

	describe "new product page" do
		describe "for normal user" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				sign_in user
				visit new_product_path
			end
			it { should have_content('You do not have sufficient privileges to view this page!') }
		end

		describe "for user not signed in" do
			before do
				visit new_product_path
			end
			it { should have_content('You need to sign in or sign up before continuing.') }
		end

		describe "for admin user" do
			let(:admin) { FactoryGirl.create(:admin) }
			before do
				sign_in admin
				visit new_product_path
			end
			it { should have_selector('h1', text: 'Add A Product Listing') }
		end

		describe "upload listings" do
			let(:admin) { FactoryGirl.create(:admin) }
			before do
				sign_in admin
				visit new_product_path
			end

			it { should have_selector('h1', text: 'Add A Product Listing') }

			describe "with invalid information" do
				let(:submit) { "Submit" }
				it "should not create a listing" do
					expect { click_button submit }.not_to change(Product, :count)
				end

				describe "error messages" do
					before { click_button submit }
					it { should have_content('error') }
				end
			end

			describe "with valid upload" do
				let(:submit) { "Submit" }
				before do
					fill_in "product_title",			with: "Example Title"
					fill_in "product_description",		with: "Example Description"
					fill_in "product_price",			with: 5.99
					fill_in "product_shipping_price",	with: 6.66
					attach_file "product_image", 'spec/fixtures/images/rails.png'
				end

				it "should create a product listing" do
					expect { click_button submit }.to change(Product, :count).by(1)
				end
			end
		end
	end
end
