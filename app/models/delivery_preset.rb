class DeliveryPreset < ActiveRecord::Base
  belongs_to :store
  
  has_many :line_items, :dependent => :destroy
  has_many :items, :through => :line_items
  
  named_scope :by_day, :order => "day_of_week ASC"
  
  def self.build_defaults
    %w(sun mon tue wed thu fri sat).each do |day|
      delivery_preset = create(:day_of_week => day)
      Item.available.each do |item|
        delivery_preset.line_items.create(
          :quantity => 12,
          :item => item
        )
      end
    end
  end
  
  def update_line_items(*args)
    args.each do |line_item|
      item = Item.find(line_item[:item_id])
      if existing_line_item = self.line_items.detect{ |l| l.item == item }
        existing_line_item.quantity = line_item[:quantity]
        existing_line_item.price    = line_item[:price]
        existing_line_item.save!
      else
        self.line_items.create(:item => item, :quantity => line_item[:quantity], :price => line_item[:price])
      end
    end
  end
end
