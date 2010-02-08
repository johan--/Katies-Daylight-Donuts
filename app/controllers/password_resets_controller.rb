class PasswordResetsController < ApplicationController  
  before_filter :find_perishable_token, :only => [:edit, :update]
  
  def create
    if @user = User.find_by_email(params[:email])
      @user.reset_perishable_token! && UserNotifier.deliver_password(@user)
      flash[:notice] = "Please check your email for instructions on resetting your password."
      redirect_to login_url
    else
      flash[:warning] = "Could not find anyone with that email."
      render :action => "index"
    end
  end
  
  def update
    @user.password              = params[:user][:password] 
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save!
      flash[:notice] = "You password has successfully been changed."
      redirect_to edit_user_path(@user)
    else
      render :action => "edit"
    end
  end
  
  private
  
  def find_perishable_token
    unless @user = User.find_by_perishable_token(params[:id])
      flash[:warning] = "We're sorry, but we could not locate your account. " +  
      "If you are having issues try copying and pasting the URL " +  
      "from your email into your browser or restarting the " +  
      "reset password process." 
      redirect_to root_url
    end
  end
end
