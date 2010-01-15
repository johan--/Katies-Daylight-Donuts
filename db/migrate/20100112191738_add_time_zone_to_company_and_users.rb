class AddTimeZoneToCompanyAndUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :time_zone, :string, :default => "Central Time (US & Canada)"
    add_column :companies, :time_zone, :string, :default => "Central Time (US & Canada)"
  end

  def self.down
    remove_column :users, :time_zone
    remove_column :companies, :time_zone
  end
end
