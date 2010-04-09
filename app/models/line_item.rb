class LineItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :delivery
  belongs_to :delivery_preset
  
  def total
    (quantity.to_i * price.to_f)
  end
end