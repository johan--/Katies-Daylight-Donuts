class AddBuyBackIdToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :buy_back_id, :integer
  end

  def self.down
    remove_column :line_items, :buy_back_id
  end
end
