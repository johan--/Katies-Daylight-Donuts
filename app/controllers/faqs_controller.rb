class FaqsController < ApplicationController
  before_filter :login_required
  
  def index
    respond_to do |format|
      format.html
      format.js{ render :layout => false }
    end
  end
end
