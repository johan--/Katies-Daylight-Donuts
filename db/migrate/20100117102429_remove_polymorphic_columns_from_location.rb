class RemovePolymorphicColumnsFromLocation < ActiveRecord::Migration
  def self.up
    remove_column :locations, :locatable_type
    remove_column :locations, :locatable_id
  end

  def self.down
    add_column :locations, :locatable_type, :string
    add_column :locations, :locatable_id, :integer
  end
end
