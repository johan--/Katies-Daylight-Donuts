class AddEmployeeIdToDelivery < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :employee_id, :integer
  end

  def self.down
    remove_column :deliveries, :employee_id
  end
end
