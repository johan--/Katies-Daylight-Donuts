class AddUserIdToStores < ActiveRecord::Migration
  def self.up
    add_column :stores, :user_id, :integer unless Store.columns.map(&:name).include?("user_id")
  end

  def self.down
    remove_column :stores, :user_id if Store.columns.map(&:name).include?("user_id")
  end
end
