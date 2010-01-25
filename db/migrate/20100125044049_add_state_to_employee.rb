class AddStateToEmployee < ActiveRecord::Migration
  def self.up
    add_column :employees, :state, :string
    Employee.update_all(:state => "clocked_out")
  end

  def self.down
    remove_column :employees, :state
  end
end
