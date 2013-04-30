class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :billing_address_1
      t.string :billing_address_2
      t.string :billing_state
      t.integer :billing_zip_code

      t.integer :user_id
      t.timestamps
    end
  end
end
