# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Grid Helpers
  def grid_date(date)
    date.strftime("%m/%d %I:%M%p").gsub(/(AM|PM)$/){ |match| match.downcase }
  end
  
  def pre
    link_to (image_tag('buttons/default/previous.png',:alt=>'Previous')),:date=>@date.last_month
  end

  def nex
    link_to (image_tag('buttons/default/next.png',:alt=>'Next')),:date=>@date.next_month
  end
  
  def link_to_facebox(text, url)
    link_to(text, url, :rel => "facebox")
  end

  def link_to_ibox(text, id, options = {}, &block)
    content_tag(:div, :id => id, :style => "display: none;") do
      yield block if block_given?
    end.concat(
      content_tag(:a, :href => "##{id}", :rel => "ibox&amp;" + options.map{ |k,v| 
        "#{k}=#{v}"}.join("&"), :id => "link_for_#{id}", :style => "#{options[:hide] == true ? 'display: none;' : ''}"){
        text
      })
  end
  
  def current_user
    @current_user_session
  end
  
  def current(controller)
    @controller.controller_name == controller ? "current" : ""
  end
  
  def current_action(action)
    @controller.action_name == controller ? "current" : ""
  end
  
  def button(action, route, options = {})
    content_tag :p, :class => "button" do
      options.merge!(:class => "button", :href => route)
      content_tag(:a, options) do
        content_tag :span do
          action
        end
      end
    end
  end
  
  # Facebooker
  def login_or_profile_pic
    #if facebook_session
    #  fb_profile_pic facebook_session.user
    #else
    #  fb_login_and_redirect(deliveries_path)
    #end
  end
  
  def facebox_button(action, route)
    button(action, route, :rel => "facebox")
  end
  
  def list(collection, selector, &block)
    content_tag(:ul, :id => selector) do
      collection.each do |object|
        yield block
      end
    end
  end
  
  def icon(name, options = {})
    theme = options.has_key?(:theme) ? options[:theme] : "default"
    theme = "" if theme == :none
    name_and_format = name.split(".")
    name,format = name_and_format[0],name_and_format[1]
    format = "png" if format.nil?
    if File.exists?(RAILS_ROOT + "/public/images/icons/#{theme}/#{name}.#{format}")
      if options.has_key?(:class)
        options[:class] << " icon" 
      else
        options[:class] = "icon"
      end
      unless theme.blank?
        image_tag("icons/#{theme}/#{name}.#{format}", options)
      else
        image_tag("icons/#{name}.#{format}", options)
      end#.concat(" " + options[:text])
    end
  end
  
  def draggable_routes_js(routes = [])
    js = ""
    routes.each do |route|
      js << draggable_elelment("route_#{route.id}", {:revert => true})
    end
    js
  end
  
  def current_action
    @controller.action_name if defined?(@controller)
  end
  
  def current_controller
    @controller.controller_name if defined?(@controller)
  end

  # Returns the test My Resource or Simply Resource based on user role as text value
  # Example:
  #   user = non_admin_user
  #   controller = OrdersController.new
  #   personalized_title_for(user, controller) #=> My Orders
  def personalized_title_for(user, controller)
    klass_name = controller.controller_name.titleize
    controller.action_name =~ /index/ ? "#{'My ' unless user.system_user?} #{klass_name}" : "#{'My ' unless user.system_user?}#{klass_name} / #{controller.action_name.titleize}"
  end
  
  def google_map_from_store(store)
    map = GMap.new("map")
     map.control_init(:map_type => true)
     map.center_zoom_init(store.geocode_array, 11)
     map.icon_global_init(GIcon.new(:image => "/images/daylight_donuts_gmarker.png",
         :shadow => "/images/daylight_donuts_gmarker.png",
         :shadow_size => GSize.new(50,28),
         :icon_anchor => GPoint.new(7,7),
         :info_window_anchor => GPoint.new(9,2)), "daylight_donuts_icon")
     icon = Variable.new("daylight_donuts_icon")
     store_marker = GMarker.new(store.geocode_array,
       :title => "#{store.name}",
       :info_window => "#{store.display_name} <br />#{store.full_address} <br />#{store.phone}",
       :icon => icon)
      map.overlay_init store_marker
      

      
      map.div(:width => 225, :height => 225)
  end
end
