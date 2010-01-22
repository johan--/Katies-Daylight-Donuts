class LineItem < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.integer :delivery_id
      t.integer :item_id
      t.integer :quantity
      t.decimal :price, :precision => 8, :scale => 2
    end
  end

  def self.down
    drop_table :line_items
  end
end
