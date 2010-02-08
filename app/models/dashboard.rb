class Dashboard
  def item_data
    Item.metrics
  end
  
  def buyback_data
    BuyBack.metrics
  end
end