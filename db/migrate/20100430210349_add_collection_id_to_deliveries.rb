class AddCollectionIdToDeliveries < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :collection_id, :integer
    add_index  :deliveries, :collection_id
  end

  def self.down
    remove_index  :deliveries, :collection_id
    remove_column :deliveries, :collection_id
  end
end
