class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :address
      t.string :city
      t.string :state
      t.integer :zipcode
      t.string :country
      t.string :phone
      t.string :fax
      t.string :email
      t.string :manager
      t.integer :customer_id
      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
