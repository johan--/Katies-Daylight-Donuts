class CreateEmployeesPositions < ActiveRecord::Migration
  def self.up
    create_table :employees_positions, :id => false, :force => true do |t|
      t.integer :employee_id
      t.integer :position_id
      t.timestamps
    end
  end

  def self.down
    drop_table :employees_positions
  end
end
