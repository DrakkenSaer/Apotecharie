class CreateHeadlines < ActiveRecord::Migration
  def up
    create_table :spree_headlines do |t|
      t.string  :title
      t.text    :body
      t.string  :poster
      t.datetime   :deleted_at

      t.timestamps
    end
    add_index :spree_headlines, [:created_at]
  end

  def down
    drop_table :spree_headlines
    remove_index :spree_headlines, [:created_at]
  end
end
