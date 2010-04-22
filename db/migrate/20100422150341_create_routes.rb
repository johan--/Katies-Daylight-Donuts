class CreateRoutes < ActiveRecord::Migration
  def self.up
    create_table :routes do |t|
      t.string :name
      t.timestamps
    end
    
    ["York Route", "Hastings Route", "ST. Paul Route", "Columbus"].each do |route_name|
      Route.create(:name => route_name)
    end
  end

  def self.down
    drop_table :routes
  end
end
