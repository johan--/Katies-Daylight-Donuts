# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
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
      end
    end
  end
  
  def draggable_routes_js(routes = [])
    js = ""
    routes.each do |route|
      js << draggable_elelment("route_#{route.id}", {:revert => true})
    end
    js
  end
end
