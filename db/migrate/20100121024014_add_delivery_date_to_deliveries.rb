class AddDeliveryDateToDeliveries < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :delivery_date, :datetime
  end

  def self.down
    remove_column :deliveries, :delivery_date
  end
end
