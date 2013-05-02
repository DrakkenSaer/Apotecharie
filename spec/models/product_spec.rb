require 'spec_helper'

describe Product do
  before do
    @product = Product.new(
	title: "Example Title", 
	description: "Example Description", 
	price: 0.99, 
	shipping_price: 5.00,
	image: File.new(Rails.root + 'spec/fixtures/images/rails.png'))
  end

  subject { @product }

  [:title, :description, :price, :shipping_price, :image].each do |n|
  	it { should respond_to(n) }
  end

  it { should be_valid }

  describe "validating image" do
    it { should have_attached_file(:image) }
    it { should validate_attachment_presence(:image) }
  end

  describe "validating numericality" do
	before do
		@product.price = "a"
		@product.shipping_price = "a"
	end
  	it {should_not be_valid}
  end

  describe "validating presence" do
	before do
		@product.title = ""
		@product.description = ""
		@product.price = ""
		@product.shipping_price = ""
		@product.image = nil
	end
  	it {should_not be_valid}
  end

  describe "when image, title, or description is not unique" do
    before do
      product_existing = @product.dup
      product_existing.save
    end
    it {should_not be_valid}
  end
end
