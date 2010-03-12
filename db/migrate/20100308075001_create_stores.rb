class CreateStores < ActiveRecord::Migration
  def self.up
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
      t.integer :user_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :stores
  end
end
