class CreateDeliveries < ActiveRecord::Migration
  def self.up
    create_table :deliveries do |t|
      t.integer :customer_id
      t.boolean :delivered
      t.timestamps
    end
  end
  
  def self.down
    drop_table :deliveries
  end
end
