class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.string :item_type
      t.decimal :price
      t.boolean :available

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
