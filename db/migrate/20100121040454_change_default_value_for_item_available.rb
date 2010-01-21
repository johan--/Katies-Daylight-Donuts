class ChangeDefaultValueForItemAvailable < ActiveRecord::Migration
  def self.up
    remove_column :items, :available
    add_column :items, :available, :boolean, {:default => true}
  end

  def self.down
    remove_column :items, :available
    add_column :items, :available, :boolean
  end
end
