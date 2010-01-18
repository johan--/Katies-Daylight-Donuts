class AddDeliveredAtToDeliveries < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :delivered_at, :datetime
  end

  def self.down
    remove_column :deliveries, :delivered_at
  end
end
