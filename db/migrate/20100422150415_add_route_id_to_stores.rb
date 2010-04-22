class AddRouteIdToStores < ActiveRecord::Migration
  def self.up
    add_column :stores, :route_id, :integer
  end

  def self.down
    remove_column :stores, :route_id
  end
end
