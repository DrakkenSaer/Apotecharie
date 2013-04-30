require 'spec_helper'

describe Address do

  let(:user) { FactoryGirl.create(:user) }
  before do
    @address = user.addresses.build(
               address_1: "456 Different Street", 
               address_2: "Apt #12", state: "OR", 
               zip_code: 90000
                                 )
  end

  subject { @address }

  [:address_1, :address_2, :state, :zip_code, 
   :user_id].each do |n|

    it { should respond_to(n) }

  end

  its(:user) { should == user }
  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Address.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when user_id is not present" do
    before { @address.user_id = nil }
    it {should_not be_valid}
  end

  describe "with blank content" do
    before { @address.address_1 = "" }
    it { should_not be_valid }
  end
end
