require 'test_helper'

class DeliveryTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Delivery.new.valid?
  end
end
