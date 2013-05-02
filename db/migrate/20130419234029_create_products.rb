class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string      :title
      t.text        :description
      t.integer     :price
      t.integer     :shipping_price
      t.attachment  :image

      t.timestamps
    end
  end

  def self.down
    drop_attached_file :image
  end
end
