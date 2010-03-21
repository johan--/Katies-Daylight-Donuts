class AddCityIdToStores < ActiveRecord::Migration
  def self.up
    add_column :stores, :city_id, :integer
    remove_column :stores, :city if City.columns.map(&:name).include?("city")
  end

  def self.down
    remove_column :stores, :city_id
  end
end
