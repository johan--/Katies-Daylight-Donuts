class DeliveryPreset < ActiveRecord::Base
  belongs_to :store

  validates_presence_of :day_of_week
  
  has_many :line_items, :dependent => :destroy
  has_many :items, :through => :line_items
  
  named_scope :by_day, :order => "day_of_week ASC"
  named_scope :open, :conditions => {:closed => false}
  
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
    return false if args.first.nil?
    args.first.each do |line_item|
      item = Item.find(line_item[:item_id])
      if existing_line_item = self.line_items.detect{ |l| l.item == item }
        if line_item[:quantity].to_i == 0 
          existing_line_item.destroy
        else
          existing_line_item.quantity = line_item[:quantity]
          existing_line_item.price    = line_item[:price]
          existing_line_item.save!
        end
      elsif line_item[:quantity].to_i != 0
        self.line_items.create(:item => item, :quantity => line_item[:quantity], :price => line_item[:price])
      end
    end
  end
  
  def copy(delivery_preset)
    raise ArgumentError, "Expected DeliveryPreset got #{delivery_preset.class}" unless delivery_preset.is_a?(DeliveryPreset)
    delivery_preset.line_items.collect do |li|
      self.line_items.create(:item => li.item, :quantity => li.quantity, :price => li.item.price)
    end.all?
  end
end
