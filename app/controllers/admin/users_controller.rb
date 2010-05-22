class Admin::UsersController < ApplicationController
  before_filter :login_required
  before_filter :admin_role_required
  
  layout "admin"
  
  def index
    respond_to do |format|
      format.html
      format.json{ render :json => User.find_and_return_json(:all, 
        :offset => (params[:start] || 0), 
        :limit => (params[:limit] || 100), 
        :order => "created_at DESC", :include => [:store]), :layout => false
      }
    end
  end
  
  def search
    @users = User.paginate_search(params)
    render :update do |page|
      page.replace_html(:users, "")
      @users.each do |user|
        page.insert_html(:top, :users, :partial => user, :locals => {:row_class => cycle("oddRow","stripe")})
      end
      page << "stripe()"
    end
  end
  
  def new
    @user = User.new
    respond_to do |format|
      format.html
      format.js{ render :layout => false }
    end
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created user."
      redirect_to users_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.js{ render :layout => false }
    end
  end
  
  def show
    @user = User.find(params[:id])
    render :action => "edit"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Your account was successfully updated."
      redirect_to user_url(@user)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    if @user = User.find(params[:id])
      if @user.destroy
        flash[:notice] = "User successfully removed."
      else
        flash[:warning] = "Could not remove user."
      end
    end
    redirect_to users_path
  end
  
  def turn_off_hints
    if @current_user.show_hints?
      @current_user.update_attribute(:show_hints, false)
    end
    render :nothing => true
  end
  
  protected
  
  def find_user
    if @current_user.super? && params[:id]
      User.find_by_username(params[:id])
    else
      @current_user
    end
  end
end
