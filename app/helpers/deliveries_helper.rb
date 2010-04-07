module DeliveriesHelper
  def delivery_action_link(delivery, button = false)
    return if delivery.new_record?
    case delivery.state
    when /^pending$/i
      unless button
        link_to "Deliver", deliver_delivery_path(delivery)
      else
        button "Deliver", deliver_delivery_path(delivery)
      end
    when /^delivered$/i
      unless button
        link_to "Undeliver", undeliver_delivery_path(delivery)
      else
        button "Undeliver", undeliver_delivery_path(delivery)
      end
    else
      delivery.state.titleize
    end
  end
end
