class Admin::StoresController < ApplicationController
  before_filter :login_required
  before_filter :admin_role_required
  
  layout "admin"
  
  def index
    @routes = Route.all
    @stores = Store.all_by_position
    respond_to do |format|
      format.html
      format.pdf{ render :layout => false }
      # API XML Calls
      format.xml{ render :xml => @stores.to_xml(:only => [:name, :address, :state, :zipcode, :country], :methods => [:city_name])}
      # API Json Calls
      format.json{ render :xml => @stores.to_json(:only => [:name, :address, :state, :zipcode, :country], :methods => [:city_name])}      
    end
  end
  
  def show
    @store = Store.find(params[:id], :joins => [:delivery_presets], :include => [:deliveries, :user])
    @store.delivery_presets.build_defaults if @store.delivery_presets.empty?
  end
  
  def new
    @store = Store.new
    respond_to do |format|
      format.html
      format.js{ render :layout => false }
    end
  end
  
  def create
    @store = Store.new(params[:store])
    if @store.save
      flash[:notice] = "Successfully created store."
      redirect_to [:admin,@store]
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
      redirect_to [:admin,@store]
    else
      render :action => 'edit'
    end
  end
  
  def search
    params[:store_name] ||= ""
    @stores = Store.find(:all, :conditions => ["LOWER(name) like ?",'%' +params[:store_name].downcase + "%"])
    render :update do |page|
      page.replace_html(:stores, :partial => @stores)
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
    redirect_to admin_stores_url
  end
end
