# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def current_user
    @current_user_session
  end
  
  def current(controller)
    @controller.controller_name == controller ? "current" : ""
  end
end
