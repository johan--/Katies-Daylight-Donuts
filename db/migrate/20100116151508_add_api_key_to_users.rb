class AddApiKeyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :api_key, :string
    add_column :users, :api_enabled, :boolean, :default => false
  end

  def self.down
    remove_column :users, :api_key
    remove_column :users, :api_enabled
  end
end
