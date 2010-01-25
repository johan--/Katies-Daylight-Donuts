class AddWeightToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :weight, :decimal, :precision => 8, :scale => 2, :default => 0.0
  end

  def self.down
    remove_column :items, :weight
  end
end
