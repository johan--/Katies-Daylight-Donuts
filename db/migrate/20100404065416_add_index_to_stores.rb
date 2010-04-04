class AddIndexToStores < ActiveRecord::Migration
  def self.up
    add_index(:stores, :position)
  end

  def self.down
    remove_index(:stores, :position)
  end
end
