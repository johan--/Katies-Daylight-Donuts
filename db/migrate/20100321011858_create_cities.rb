class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :name
      t.timestamps
    end
    
    City.list.each do |city|
      city = City.find_or_create_by_name(city)
      stores_in_city = Store.find(:all, :conditions => ["city = ?", city])
      stores_in_city.each do |store|
        store.city = city
        store.save
      end
    end
  end

  def self.down
    drop_table :cities
  end
end
