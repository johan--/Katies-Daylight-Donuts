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
        content_tag :p do
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
    if File.exists?(RAILS_ROOT + "/public/images/icons/default/#{name}.png")
      if options.has_key?(:class)
        options[:class] << " icon" 
      else
        options[:class] = "icon"
      end
      image_tag("icons/default/#{name}.png", options)
    end
  end
end
