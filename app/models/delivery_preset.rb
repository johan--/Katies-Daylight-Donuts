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
end
