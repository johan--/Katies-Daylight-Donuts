class AddClockinIdToEmployees < ActiveRecord::Migration
  def self.up
    add_column :employees, :clockin_id, :integer
  end

  def self.down
    remove_column :employees, :clockin_id
  end
end
