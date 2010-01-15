class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :name
      t.string :time_zone
      t.string :email
      t.timestamps
    end
    
    # Create the initial setting
    Setting.create!(
      :email => "no-reply@katiesdaylightdonuts.com",
      :name => "Katies Daylight Donuts",
      :time_zone => "Central Time (US & Canada)")
  end
  
  def self.down
    drop_table :settings
  end
end
