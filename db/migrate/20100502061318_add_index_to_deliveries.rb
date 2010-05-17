class AddIndexToDeliveries < ActiveRecord::Migration
  def self.up
    add_index :deliveries, :store_id
  end

  def self.down
    remove_index :deliveries, :store_id
  end
end
