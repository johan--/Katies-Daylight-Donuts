class DeliveriesController < ApplicationController  
  before_filter :login_required, :except => [:index]
  before_filter :current_user_session
  before_filter :find_delivery_with_item, :only => [:add_item, :remove_item]

  auto_complete_for :item, :name
  auto_complete_for :item, :item_type
  
  def index
    @delivery_klass = current_user.admin? ? Delivery : current_user.store.deliveries
    if params[:status] == "pending"
      @deliveries = @delivery_klass.pending
    elsif params[:status] == "delivered"
      @deliveries = @delivery_klass.delivered
    else
      @deliveries = @delivery_klass.all
    end
    respond_to do |format|
      format.html
      format.xml{ render :xml => @deliveries.to_xml(:include => [:store]) }
    end
  end
  
  # TODO: remove these actions
  def add_item
    @line_item = @delivery.add_item(@item, params[:quantity]) if @delivery && @item
    render :update do |page|
      page.insert_html(:top, :items, :partial => "line_item_form", :locals => {:delivery_line_item => @line_item})
      page.visual_effect(:highlight, :items)
      page.show(:items_table)
    end
  end
  
  # TODO: remove these actions
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
    @map = GMap.new("map")
    @map.control_init(:large_map => true,:map_type => true)
    @map.center_zoom_init(@delivery.store.geocode_array, 11)
    @map.icon_global_init(GIcon.new(:image => "/images/daylight_donuts_gmarker.png",
        :shadow => "/images/daylight_donuts_gmarker.png",
        :shadow_size => GSize.new(50,28),
        :icon_anchor => GPoint.new(7,7),
        :info_window_anchor => GPoint.new(9,2)), "daylight_donuts_icon")
    icon = Variable.new("daylight_donuts_icon")
    store_marker = GMarker.new(@delivery.store.geocode_array,
      :title => "#{@delivery.store.name}",
      :info_window => "#{@delivery.store.full_address} <br />#{@delivery.store.phone}",
      :icon => icon)
     @map.overlay_init store_marker
  end
  
  def new
    @delivery = Delivery.new
    @delivery.add_items
  end
  
  def create
    line_items = params[:delivery].delete(:line_items)
    @delivery = Delivery.new(params[:delivery])
    line_items.each{ |l| @delivery.line_items.build(l) }
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
    line_items = params[:delivery].delete(:line_items)
    if @delivery.update_attributes(params[:delivery]) && @delivery.update_line_items(line_items)
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
    @delivery_klass = current_user.admin? ? Delivery : current_user.store.deliveries
    @deliveries = @delivery_klass.delivered
    render :action => "index"
  end
  
  def pending
    @delivery_klass = current_user.admin? ? Delivery : current_user.store.deliveries
    @deliveries = @delivery_klass.pending
    render :action => "index"
  end
  
  def map
    @deliveries = Delivery.pending(
      :origin => "68826", 
      :within => 500, 
      :order => "distance asc",
      :include => [:store]
    )
    @stores = @deliveries.map(&:store)
       @map = GMap.new("map")
       @map.control_init(:large_map => true,:map_type => true)
       @map.center_zoom_init(@stores.first.geocode_array, 11)
       @stores.each do |store|
         
         @map.icon_global_init(GIcon.new(:image => "/images/daylight_donuts_gmarker.png",
             :shadow => "/images/daylight_donuts_gmarker.png",
             :shadow_size => GSize.new(50,28),
             :icon_anchor => GPoint.new(7,7),
             :info_window_anchor => GPoint.new(9,2)), "daylight_donuts_icon")
          icon = Variable.new("daylight_donuts_icon")
         
         store_marker = GMarker.new(store.geocode_array,
          :title => "#{store.name}",
          :info_window => "#{store.full_address} <br />#{store.phone}",
          :icon => icon)
         #@map.overlay_init GPolyline.new(@stores.map(&:geocode_array))
         @map.overlay_init store_marker
       end
  end

  def print_todays
    @deliveries = Delivery.pending.by_date
    render :layout => false
  end
  
  def generate_todays
    Store.all.each do |store|
      store.deliveries.create_default_delivery
    end
    redirect_to deliveries_path
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
