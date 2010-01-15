class AddGeocodeToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :lat, :string
    add_column :locations, :lng, :string
  end

  def self.down
    remove_column :locations, :geocode
  end
end
