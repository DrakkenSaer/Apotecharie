class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_1
      t.string :address_2
      t.string :state
      t.integer :zip_code

      t.integer :user_id
      t.timestamps
    end
  end
end
