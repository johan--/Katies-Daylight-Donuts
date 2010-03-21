class AddLockedToDeliveries < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :locked, :boolean
  end

  def self.down
    remove_column :deliveries, :locked
  end
end
