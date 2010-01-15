class AddLocationIdAsDeliveryParentFk < ActiveRecord::Migration
  def self.up
    remove_column :deliveries,:customer_id
    add_column :deliveries,:location_id, :integer
  end

  def self.down
    add_column :deliveries, :customer_id, :integer
    remove_column :deliveries,:location_id
  end
end
