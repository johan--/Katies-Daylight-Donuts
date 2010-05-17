class AddHasSpecialPricingToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :has_special_pricing, :boolean
  end

  def self.down
    remove_column :users, :has_special_pricing
  end
end
