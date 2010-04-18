class AddAddressFieldsToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :address, :string
    add_column :settings, :city, :string
    add_column :settings, :state, :string
    add_column :settings, :country, :string
    add_column :settings, :zipcode, :string
    add_column :settings, :phone, :string
    add_column :settings, :lat, :string
    add_column :settings, :lng, :string
    add_column :settings, :manager_name, :string
  end

  def self.down
    remove_column :settings, :manager_name
    remove_column :settings, :lng
    remove_column :settings, :lat
    remove_column :settings, :phone
    remove_column :settings, :zipcode
    remove_column :settings, :country
    remove_column :settings, :state
    remove_column :settings, :city
    remove_column :settings, :address
  end
end
