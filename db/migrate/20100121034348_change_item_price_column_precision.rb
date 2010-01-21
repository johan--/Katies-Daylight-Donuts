class ChangeItemPriceColumnPrecision < ActiveRecord::Migration
  def self.up
    remove_column :items, :price
    add_column :items, :price, :decimal, :precision => 8, :scale => 2, :default => 0.00
  end

  def self.down
    remove_column :items, :price
    add_column :items, :price, :decimal
  end
end
