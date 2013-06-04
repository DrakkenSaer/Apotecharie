require 'spec_helper'

describe "Headline Pages" do

  subject { page }

  describe "index" do
    before {visit spree.headlines_path}
    it { should have_selector('h1', text: "News") }
  end
end