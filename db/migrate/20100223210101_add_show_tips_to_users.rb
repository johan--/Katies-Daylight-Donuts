class AddShowTipsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :show_tips, :boolean, :default => true
  end

  def self.down
    remove_column :users, :show_tips
  end
end
