class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :name
      t.string :time_zone
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.string :phone
      t.string :lat
      t.string :lng
      t.string :manager_name
      t.timestamps
    end
    
    create_table :cities do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :stores do |t|
      t.string :name
      t.string :store_no
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.string :phone
      t.string :fax
      t.string :email
      t.string :url
      t.string :lat
      t.string :lng
      t.timestamps
    end
    
    City.list.each do |city|
      city = City.find_or_create_by_name(city)
      stores_in_city = Store.find(:all, :conditions => ["city = ?", city.name])
      stores_in_city.each do |store|
        store.city = city
        store.save
      end
    end
    
    # Create the initial setting
    Setting.create!(
      :email => "no-reply@katiesdaylightdonuts.com",
      :name => "Katies Daylight Donuts",
      :time_zone => "Central Time (US & Canada)")
  end
  
  def self.down
    drop_table :settings
    drop_table :cities
    drop_table :stores
  end
end
