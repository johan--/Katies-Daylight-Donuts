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
end
