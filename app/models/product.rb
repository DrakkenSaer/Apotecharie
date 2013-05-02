class Product < ActiveRecord::Base
	attr_accessible :title, :description, :price, :shipping_price, 
					:image

	validates :price, numericality: true, presence: true
	validates :shipping_price, numericality: true, presence: true

	[:title, :description].each do |n|
		validates n, presence: true, uniqueness: true
	end

	has_attached_file :image,
		styles: {
			thumb: "100x100>",
			small: "150x150>",
			medium: "300x300>",
			large:   "400x400>"},
	default_url: "/images/:style/missing.png"

	validates_attachment :image, presence: true

end
