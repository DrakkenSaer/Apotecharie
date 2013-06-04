class AddPermalinkToHeadline < ActiveRecord::Migration
  def self.up
    add_column :spree_headlines, :permalink, :string
    add_index :spree_headlines, :permalink
  end
  def self.down
    remove_column :spree_headlines, :permalink
  end
end