class AddMobileNumberToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :mobile_number, :string
  end

  def self.down
    remove_column :users, :mobile_number
  end
end
