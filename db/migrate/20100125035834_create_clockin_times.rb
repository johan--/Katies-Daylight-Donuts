class CreateClockinTimes < ActiveRecord::Migration
  def self.up
    create_table :clockin_times do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :employee_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :clockin_times
  end
end
