class DeliveryPreset < ActiveRecord::Base
  belongs_to :store

  validates_presence_of :day_of_week
  
  has_many :line_items, :dependent => :destroy
  has_many :items, :through => :line_items
  
  named_scope :by_day, :order => "day_of_week ASC"
  named_scope :open, :conditions => {:closed => false}
  
  def position
    case day_of_week.downcase
    when "sun"
      0
    when "mon"
      1
    when "tue"
      2
    when "wed"
      3
    when "thu"
      4
    when "fri"
      5
    when "sat"
      6
    else
      0
    end
  end
  
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
  
  def self.copy_attributes(from_model, to_model)
    [from_model, to_model].each do |object|
      raise ArgumentError, "Expected #{DeliveryPreset} got #{object.class}" unless object.is_a?(DeliveryPreset)
    end
    to_model.line_items.each_with_index do |line,index|
      from_line_item = from_model.line_items[index]
      if from_line_item.item_id == line.item_id
        line.quantity,line.price = from_line_item.quantity,from_line_item.price        
        line.save!
      end
    end
    to_model.closed = from_model.closed 
    to_model.save!
  end
  
  def copy(delivery_preset)
    raise ArgumentError, "Expected DeliveryPreset got #{delivery_preset.class}" unless delivery_preset.is_a?(DeliveryPreset)
    self.line_items.destroy_all
    delivery_preset.line_items.collect do |li|
      line_items.create(:item => li.item, :quantity => li.quantity, :price => li.item.price)
    end.all?
  end
end
