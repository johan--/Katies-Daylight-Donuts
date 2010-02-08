class LocationsController < ApplicationController
  before_filter :login_required, :except => [:index, :search]
  before_filter :current_user_session
  
  auto_complete_for :location, :address
  auto_complete_for :location, :zipcode
  auto_complete_for :location, :city
  
  def search
    flash[:notice] = "Feature has been disabled."
    if !params[:zipcode].blank? and !params[:miles].to_s.blank?
      @locations = Location.find_within(params[:miles].to_s, :origin => params[:zipcode])
      render :action => "index"
    else
      flash[:error] = "Could not find any locations near zipcode."
      redirect_to locations_path
    end
  end
  
  def presets
    @presets = []
    if @location = Location.find(params[:id])
      @presets = @location.deliveries.delivered(:include => :items, :limit => 10, :order => "delivered_at asc")
    end
    
    render :update do |page|
      page.replace_html(:presets,"") # empty the list

      @presets.each do |preset| # Add to the new list
        page.insert_html(:top, :presets, :partial => "preset", :locals => {:delivery => preset})
      end
    end
  end
  
  def index
    # Only need Customer Locations
    if params[:customer_id]
      @customers = [Customer.find(params[:customer_id], :include => [:locations])]
    else
      @customers = Customer.find(:all, :include => [:locations])
    end
  end
  
  def show
    @location = Location.find(params[:id])
  end
  
  def new
    @location = Location.new
  end
  
  def create
    @customer = Customer.find(params[:location][:customer_id])
    @location = @customer.locations.new(params[:location])
    if @location.save
      flash[:notice] = "Successfully created location."
      redirect_to @location
    else
      render :action => 'new'
    end
  end
  
  def edit
    @location = Location.find(params[:id])
  end
  
  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
      flash[:notice] = "Successfully updated location."
      redirect_to @location
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    flash[:notice] = "Successfully destroyed location."
    redirect_to :action => "index"
  end
end
