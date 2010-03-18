class LineItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :delivery
  belongs_to :delivery_preset
end