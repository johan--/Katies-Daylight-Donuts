class UserSessionsController < ApplicationController  
  def new
    @user_session = UserSession.new
  end
  
  def create 
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      if current_user and current_user.has_roles?(:admin, :employee)
        redirect_to pending_deliveries_url
      #elsif current_user
        #if @current_user.facebooker?
        #  fb_login_and_redirect(edit_user_path(current_user))
        #else
        #  redirect_to edit_user_path(current_user)
        #end
      elsif current_user
        redirect_to edit_user_path(current_user)
      end
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find
    if @user_session
      # session[:facebook_session] = nil if session[:facebook_session]
      @user_session.destroy
    end
    flash[:notice] = "Successfully logged out."
    redirect_to login_path
  end
    
  def forgot_password
    value = params[:user_session][:username]
    if @user = User.find(:first, :conditions => ["username = ? or email = ?", value, value])
      @user.reset_password!
      render :update do |page|
        page.hide("forgot_password_form")
        page.show("login_form")
      end
    else
      render :update do |page|
        page.replace_html("forgot_password_form_error", "Could not find any user with that login or email.")
      end
    end
  end
end
