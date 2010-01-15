class AddStatusToDeliveries < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :state, :string
  end

  def self.down
    remove_column :deliveries, :state
  end
end
