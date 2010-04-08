class AddPaidToDeliveries < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :paid, :boolean, :default => false
  end

  def self.down
    remove_column :deliveries, :paid
  end
end
