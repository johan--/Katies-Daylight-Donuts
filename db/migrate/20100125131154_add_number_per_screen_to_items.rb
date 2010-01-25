class AddNumberPerScreenToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :number_per_screen, :integer, :default => 25
  end

  def self.down
    remove_column :items, :number_per_screen
  end
end
