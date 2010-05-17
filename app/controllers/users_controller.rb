class UsersController < ApplicationController
  before_filter :login_required
  
  def edit
    @user = current_user
    render :layout => false
  end
  
  def show
    @user = current_user
    render :action => "edit"
  end
end
