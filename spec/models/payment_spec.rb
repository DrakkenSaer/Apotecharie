require 'spec_helper'

describe Payment do

  let(:user) { FactoryGirl.create(:user) }
  before do
    @payment = user.payments.build(
               billing_address_1: "123 Example Street", 
               billing_address_2: "Suite #10", 
               billing_state: "WA", 
               billing_zip_code: 99999,
                                 )
  end

  subject { @payment }

  [:billing_address_1, :billing_address_2, :billing_state, 
   :billing_zip_code, :user_id].each do |n|

    it { should respond_to(n) }

  end

  its(:user) { should == user }
  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Payment.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when user_id is not present" do
    before { @payment.user_id = nil }
    it {should_not be_valid}
  end

  describe "with blank content" do
    before { @payment.billing_address_1 = "" }
    it { should_not be_valid }
  end

end
