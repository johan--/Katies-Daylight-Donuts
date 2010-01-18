class CreateBuyBacks < ActiveRecord::Migration
  def self.up
    create_table :buy_backs do |t|
      t.integer :delivery_id
      t.string :state
      t.decimal :tax
      t.decimal :price
      t.integer :raised_donut_count
      t.integer :cake_donut_count
      t.integer :roll_count
      t.integer :donuthole_count
      t.timestamps
    end
  end
  
  def self.down
    drop_table :buy_backs
  end
end
