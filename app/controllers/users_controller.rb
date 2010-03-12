class UsersController < ApplicationController
  before_filter :login_required, :only => [:new, :edit,:update]
  before_filter :admin_role_required, :except => [:edit, :update, :show]
  
  def index
    @users = User.all
  end
  
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
    @user = find_user
  end
  
  def show
    @user = find_user
    render :action => "edit"
  end
  
  def update
    @user = find_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Your account was successfully updated."
      redirect_to user_url(@user)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    if @user = User.find_by_username(params[:id])
      if @user.destroy
        flash[:notice] = "User successfully removed."
      else
        flash[:warning] = "Could not remove user."
      end
    end
    redirect_to users_path
  end
  
  protected
  
  def find_user
    if current_user.super? && params[:id]
      User.find_by_username(params[:id])
    else
      current_user
    end
  end
end
