class AddTrayTypeToStores < ActiveRecord::Migration
  def self.up
    add_column :stores, :tray_type, :string
  end

  def self.down
    remove_column :stores, :tray_type
  end
end
