class CreateDeliveryPresets < ActiveRecord::Migration
  def self.up
    create_table :delivery_presets do |t|
      t.integer :store_id
      t.string :day_of_week

      t.timestamps
    end
  end

  def self.down
    drop_table :delivery_presets
  end
end
