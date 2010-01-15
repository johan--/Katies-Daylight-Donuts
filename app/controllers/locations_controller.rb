class LocationsController < ApplicationController
  before_filter :login_required, :except => [:index, :search]
  before_filter :find_locatable, :except => [:index]
  
  def search
    flash[:notice] = "Feature has been disabled."
    redirect_to :action => "index"
    # if !params[:zipcode].blank? and !params[:miles].to_s.blank?
    #   @locations = Location.find_within(params[:miles].to_s, :origin => params[:zipcode])
    #   render :action => "index"
    # else
    #   flash[:error] = "Could not find any locations near zipcode."
    #   redirect_to locations_path
    # end
  end
  
  def index
    @locations = Location.all
  end
  
  def show
    @locatable = find_locatable
    @location = @locatable.locations.find(params[:id])
  end
  
  def new
    if @locatable = find_locatable
      @location = @locatable.locations.build
    else
      render :action => "index"
    end
  end
  
  def create
    @locatable = find_locatable
    @location = @locatable.locations.new(params[:location])
    if @location.save
      flash[:notice] = "Successfully created location."
      redirect_to_locatable @location
    else
      render :action => 'new'
    end
  end
  
  def edit
    @locatable = find_locatable
    @location = @locatable.locations.find(params[:id])
  end
  
  def update
    @locatable = find_locatable
    @location = @locatable.locations.find(params[:id])
    if @location.update_attributes(params[:location])
      flash[:notice] = "Successfully updated location."
      redirect_to_locatable @location
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @locatable = find_locatable
    @location = @locatable.locations.find(params[:id])
    @location.destroy
    flash[:notice] = "Successfully destroyed location."
    redirect_to_locatable @location
  end
  
  protected
  
  def redirect_to_locatable(location)
    locatable = location.locatable
    if locatable.is_a?(Customer)
      redirect_to customer_path(locatable,location)
    elsif locatable.is_a?(Setting)
      redirect_to settings_path
    else
    end
  end
  
  def find_locatable
    params.each do |name, value|
      if name =~ /^(.+)_id$/
        return $1.classify.constantize.find(value, :include => [:locations])
      end
    end
    nil
  end
end
