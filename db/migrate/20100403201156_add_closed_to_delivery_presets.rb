class AddClosedToDeliveryPresets < ActiveRecord::Migration
  def self.up
    add_column :delivery_presets, :closed, :boolean
  end

  def self.down
    remove_column :delivery_presets, :closed
  end
end
