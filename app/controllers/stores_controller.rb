class StoresController < ApplicationController
  before_filter :login_required
  
  def index
    @stores = Store.all
  end
  
  def show
    @store = Store.find(params[:id], :joins => [:delivery_presets], :include => [:deliveries, :user])
    @store.delivery_presets.build_defaults if @store.delivery_presets.empty?
  end
  
  def new
    @store = Store.new
  end
  
  def create
    @store = Store.new(params[:store])
    if @store.save
      flash[:notice] = "Successfully created store."
      redirect_to @store
    else
      render :action => 'new'
    end
  end
  
  def edit
    @store = Store.find(params[:id])
  end
  
  def update
    @store = Store.find(params[:id])
    if @store.update_attributes(params[:store])
      flash[:notice] = "Successfully updated store."
      redirect_to @store
    else
      render :action => 'edit'
    end
  end
  
  def sort
    params[:stores].each_with_index do |id, index|
      Store.update_all(['position = ?', index+1],['id = ?', id])
    end
    render :nothing => true
  end
  
  def destroy
    @store = Store.find(params[:id])
    @store.destroy
    flash[:notice] = "Successfully destroyed store."
    redirect_to stores_url
  end
end
