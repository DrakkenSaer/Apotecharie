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

  describe "News page" do
    before {visit news_path}
    let(:page_title) {'News'}
    it { should have_selector('h1', text: "News") }
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
end