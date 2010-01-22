class DeliveriesController < ApplicationController  
  before_filter :login_required, :except => [:index]
  before_filter :current_user_session
  before_filter :find_delivery_with_item, :only => [:add_item, :remove_item]

  auto_complete_for :item, :name
  auto_complete_for :item, :item_type
  
  def index
    if params[:status] == "pending"
      @deliveries = Delivery.pending
    elsif params[:status] == "delivered"
      @deliveries = Delivery.delivered
    else
      @deliveries = Delivery.all
    end
    respond_to do |format|
      format.html
      format.xml{ render :xml => @deliveries.to_xml(:include => [:customer, :location]) }
    end
  end
  
  # TODO: remove these actions
  def add_item
    @delivery.add_item(@item) if @delivery && @item
    render :update do |page|
      page.insert_html(:top, :items, :partial => "item_form", :locals => {:item_record => @item})
      page.visual_effect(:highlight, :items)
      page.show(:items_table)
    end
  end
  
  def remove_item
    @delivery.remove_item(@item) if @delivery && @item
    render :update do |page|
      page.remove("item_#{@item.id}")
      page.visual_effect(:highlight, :items)
      page.show(:items_table)
    end
  end
  
  def show
    @delivery = Delivery.find(params[:id])
  end
  
  def new
    @delivery = Delivery.new
  end
  
  def create
    @delivery = Delivery.new(params[:delivery])
    if @delivery.save
      flash[:notice] = "Successfully created delivery."
      redirect_to @delivery
    else
      render :action => 'new'
    end
  end
  
  def edit
    @delivery = Delivery.find(params[:id])
  end
  
  def update
    @delivery = Delivery.find(params[:id])
    if @delivery.update_attributes(params[:delivery])
      flash[:notice] = "Successfully updated delivery."
      redirect_to @delivery
    else
      render :action => 'edit'
    end
  end
  
  def deliver
    @delivery = Delivery.pending.find(params[:id])
    if @delivery.deliver!
      flash[:notice] = "Delivery was successfully delivered."
      redirect_to pending_deliveries_url
    else
      flash[:warning] = "Could not deliver delivery."
      render :action => "index"
    end
  end
  
  def undeliver
    @delivery = Delivery.delivered.find(params[:id])
    if @delivery.undeliver!
      flash[:notice] = "Delivery was successfully undelivered."
      redirect_to delivered_deliveries_url
    else
      flash[:warning] = "Could not undeliver delivery."
      render :action => "index"
    end
  end
  
  def delivered
    @deliveries = Delivery.delivered
    render :action => "index"
  end
  
  def pending
    @deliveries = Delivery.pending
    render :action => "index"
  end
  
  def map
    @deliveries = Delivery.pending(
      :origin => "68826", 
      :within => 500, 
      :order => "distance asc",
      :include => [:location]
    )
    @locations = @deliveries.map(&:location)
       @map = GMap.new("map")
       @map.control_init(:large_map => true,:map_type => true)
       @map.center_zoom_init(@locations.first.geocode_array, 11)
       @locations.each do |location|
         
         @map.icon_global_init(GIcon.new(:image => "/images/daylight_donuts_gmarker.png",
             :shadow => "/images/daylight_donuts_gmarker.png",
             :shadow_size => GSize.new(50,28),
             :icon_anchor => GPoint.new(7,7),
             :info_window_anchor => GPoint.new(9,2)), "daylight_donuts_icon")
          icon = Variable.new("daylight_donuts_icon")
         
         location_marker = GMarker.new(location.geocode_array,
          :title => "#{location.customer.name}",
          :info_window => "#{location.full_address} <br />#{location.phone}",
          :icon => icon)
         #@map.overlay_init GPolyline.new(@locations.map(&:geocode_array))
         @map.overlay_init location_marker
       end
  end
  
  def destroy
    @delivery = Delivery.find(params[:id])
    @delivery.destroy
    flash[:notice] = "Successfully destroyed delivery."
    redirect_to deliveries_url
  end
  
  protected
  
  def find_delivery_with_item
    @delivery = Delivery.find(params[:id])
    @item = Item.available.find(params[:item_id])
  end
end
