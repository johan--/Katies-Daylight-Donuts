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
  
  def index
    # Only need Customer Locations
    @customers = Customer.find(:all, :include => [:locations])
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
