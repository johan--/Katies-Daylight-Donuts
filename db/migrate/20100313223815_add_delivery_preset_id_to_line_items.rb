class AddDeliveryPresetIdToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :delivery_preset_id, :integer
  end

  def self.down
    remove_column :line_items, :delivery_preset_id
  end
end
