class StoresController < ApplicationController
  before_filter :login_required
  
  def new
    if current_user.store?
      @store = current_user.store
      render :action => "edit"
    else
      @store = Store.new
    end
  end
  
  def edit
    if @current_user.store?
      @store = @current_user.store
    else
      @store = @current_user.store.new
      render :action => "new"
    end
  end
  
  #alias_method :show, :edit
  
  def create
    params[:store][:user_id] = current_user.id
    @store = Store.new(params[:store])
    if @store.save
      flash[:notice] = "Your all set."
      redirect_to store_deliveries_path(@store)
    else
      flash[:warning] = "Sorry, something is missing here."
      render :action => "new"
    end
  end
end