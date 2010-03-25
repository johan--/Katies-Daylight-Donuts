class AddPositionToStores < ActiveRecord::Migration
  def self.up
    add_column :stores, :position, :integer, :default => nil
  end

  def self.down
    remove_column :stores, :position
  end
end
