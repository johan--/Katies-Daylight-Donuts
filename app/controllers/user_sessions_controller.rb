class UserSessionsController < ApplicationController  
  layout "external"
  
  def new
    @user_session = UserSession.new
  end
  
  def create 
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = 'Successfully logged in.'
      redirect_to root_url
    else
      flash[:warning] = %(We didn't recognize the username or password you entered. Please try again.)
      render :action => "new"
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
