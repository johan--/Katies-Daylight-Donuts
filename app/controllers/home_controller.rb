class HomeController < ApplicationController
  before_filter :ensure_user_has_store
  
  layout "external"
  
  def show
  end
end
