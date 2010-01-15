class UsersController < ApplicationController
  before_filter :login_required, :only => [:edit,:update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created user."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Your account was successfully updated."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
end
