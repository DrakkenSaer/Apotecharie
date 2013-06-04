require 'spec_helper'

describe Spree::Headline do

	let(:headline) { FactoryGirl.create(:headline) }

	subject { headline }

	it { should respond_to(:title) }
	it { should respond_to(:body) }

	describe "when title is not present" do
		before { headline.title = "" }
		it {should_not be_valid}
	end

	describe "when body is not present" do
		before { headline.body = "" }
		it {should_not be_valid}
	end

	describe "when title exceed limit" do
		before { headline.title = "a" * 101 }
		it {should_not be_valid}
	end

	describe "when title is under limit" do
		before { headline.title = "a" }
		it {should_not be_valid}
	end

	describe "when body is under limit" do
		before { headline.body = "a" }
		it {should_not be_valid}
	end

end
