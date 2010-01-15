class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :firstname
      t.string :lastname
      t.datetime :dob
      t.string :position_type
      t.string :phone
      t.timestamps
    end
  end
  
  def self.down
    drop_table :employees
  end
end
