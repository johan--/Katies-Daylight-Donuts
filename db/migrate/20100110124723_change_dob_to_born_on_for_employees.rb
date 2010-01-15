class ChangeDobToBornOnForEmployees < ActiveRecord::Migration
  def self.up
    remove_column :employees, :dob
    add_column :employees, :born_on, :date
  end

  def self.down
    remove_column :employees, :born_on
    add_column :employees, :dob, :date
  end
end
