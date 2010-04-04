# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def current_user
    @current_user_session
  end
  
  def current(controller)
    @controller.controller_name == controller ? "current" : ""
  end
  
  def button(action, route)
    content_tag :p, :class => "button" do
      content_tag(:a, :class => "button", :href => route) do
        content_tag :span do
          action
        end
      end
    end
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
      image_tag("icons/#{theme}/#{name}.#{format}", options)
    end
  end
end
