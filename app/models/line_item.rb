class LineItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :delivery
  belongs_to :delivery_preset
  
  def total
    (quantity.to_i * price.to_f)
  end
  
  def item_type
    @item_type ||= item.item_type
  end
  
  def donut?
    item_type.to_s.downcase == "raised"
  end
  
  def donuthole?
    item_type.to_s.downcase == "donut hole"
  end
  
  def roll?
    item_type.to_s.downcase == "roll"
  end
end