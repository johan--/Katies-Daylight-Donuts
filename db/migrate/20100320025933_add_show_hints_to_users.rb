class AddShowHintsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :show_hints, :boolean, :default => true
  end

  def self.down
    remove_column :users, :show_hints
  end
end
