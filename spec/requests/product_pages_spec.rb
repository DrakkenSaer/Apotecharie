require 'spec_helper'

describe "Product Pages" do

  subject { page }

  describe "index" do
  	before {visit spree.products_path}
  	it { should have_selector('title', text: full_title("Inventory")) }
  end

end
