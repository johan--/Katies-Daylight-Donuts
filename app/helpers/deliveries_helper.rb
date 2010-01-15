module DeliveriesHelper
  def delivery_action_link(delivery)
    return if delivery.new_record?
    case delivery.state
    when /^pending$/i
      link_to "Deliver", deliver_delivery_path(delivery)
    when /^delivered$/i
      link_to "Undeliver", undeliver_delivery_path(delivery)
    else
      delivery.state
    end
  end
end
