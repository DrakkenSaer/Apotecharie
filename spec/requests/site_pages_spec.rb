require 'spec_helper'

describe "Pages" do

  subject { page }

  shared_examples_for "all pages" do
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before {visit root_path}
    let(:page_title) {''}
  end

  describe "Help page" do
    before {visit help_path}
    let(:page_title) {'Help'}
    it { should have_selector('h1', text: "FAQ") }
  end

  describe "About page" do
    before {visit about_path}
    let(:page_title) {'About'}
    it { should have_selector('h1', text: "About") }
  end

  describe "Contact page" do
    before {visit contact_path}
    let(:page_title) {'Contact'}
    it { should have_selector('h1', text: "Contact") }
  end

  describe "Admin page" do
    describe "for normal user" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit admin_path
      end
      it { should have_content('You do not have sufficient privileges to view this page!') }
    end

    describe "for user not signed in" do
      before do
        visit admin_path
      end
      it { should have_content('You need to sign in or sign up before continuing.') }
    end

    describe "for admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_in admin
        visit admin_path
      end
      it { should have_selector('h1', text: 'Administrative tools') }
    end
  end

end