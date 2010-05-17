class FaqsController < ApplicationController
  before_filter :login_required
  before_filter :ensure_user_has_store
  
  caches_page :index
  
  def index
    respond_to do |format|
      format.html
      format.js{ render :layout => false }
    end
  end
end
