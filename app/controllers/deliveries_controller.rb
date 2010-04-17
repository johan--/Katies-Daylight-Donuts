class DeliveriesController < ApplicationController  
  before_filter :login_required
  before_filter :current_user_session
  before_filter :find_delivery_with_item, :only => [:add_item, :remove_item]
  before_filter :get_current_weather, :only => [:index,:pending,:delivered]
  #before_filter :prompt_for_store_if_needed, :only => [:index, :delivered, :pending, :canceled,:printed]

  auto_complete_for :item, :name
  auto_complete_for :item, :item_type
  
  def index
    @date = params[:date] ? Date.parse(params[:date]) : Time.zone.today
    @delivery_klass = (current_user.admin? || current_user.employee?) ? Delivery : current_user.store.deliveries.by_date(@date)
    
    # Order History
    if params[:store_id] && store = Store.find(params[:store_id])
      @delivery_klass = store.deliveries.by_date(@date)
    end
    
    if params[:status] == "pending"
      @deliveries = @delivery_klass.pending.by_date(@date)
    elsif params[:status] == "delivered"
      @deliveries = @delivery_klass.delivered.by_date(@date)
    elsif params[:status] == "printed"
      @deliveries = @delivery_klass.printed.by_date(@date)
    elsif params[:status] == "canceled"
      @deliveries = @delivery_klass.canceled.by_date(@date)
    else
      @deliveries = @delivery_klass.by_date(@date)
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
    @map.control_init(:map_type => true)
    @map.center_zoom_init(@delivery.store.geocode_array, 11)
    @map.icon_global_init(GIcon.new(:image => "/images/daylight_donuts_gmarker.png",
        :shadow => "/images/daylight_donuts_gmarker.png",
        :shadow_size => GSize.new(50,28),
        :icon_anchor => GPoint.new(7,7),
        :info_window_anchor => GPoint.new(9,2)), "daylight_donuts_icon")
    icon = Variable.new("daylight_donuts_icon")
    store_marker = GMarker.new(@delivery.store.geocode_array,
      :title => "#{@delivery.store.name}",
      :info_window => "#{@delivery.store.display_name} <br />#{@delivery.store.full_address} <br />#{@delivery.store.phone}",
      :icon => icon)
     @map.overlay_init store_marker
     
  end
  
  def new
    @delivery = Delivery.new
    @delivery.add_items
  end
  
  # TODO, clean this up
  def create
    line_items = params[:delivery].has_key?(:line_items) ? params[:delivery].delete(:line_items) : []
    @delivery = Delivery.new(params[:delivery])
    line_items.each{ |l| @delivery.line_items.build(l) } unless line_items.empty?
    if @delivery.save
      flash[:notice] = "Successfully created delivery."
      redirect_to @delivery
    else
      render :action => 'new'
    end
  end
  
  def edit
    @delivery = Delivery.find(params[:id], :include => :store)
  end
  
  def update
    @delivery = Delivery.find(params[:id])
    line_items = params[:delivery].delete(:line_items) || []
    if @delivery.update_attributes(params[:delivery]) && @delivery.update_line_items(line_items)
      flash[:notice] = "Successfully updated delivery."
      redirect_to @delivery
    else
      render :action => 'edit'
    end
  end
  
  def update_status
    if params[:print]
      redirect_to :action => "print_todays", :delivery_ids => params[:delivery_ids], :format => :pdf
    else
      @deliveries = Delivery.find(params[:delivery_ids])
      @deliveries.each do |delivery|
        delivery.send(:"#{params[:message]}!") if delivery.respond_to?(:"#{params[:message]}!")
      end
      redirect_to pending_deliveries_path
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
  
  def printed
    @date = params[:date] ? params[:date].to_date : Date.today
    @delivery_klass = (current_user.admin? || current_user.employee?) ? Delivery : current_user.store.deliveries
    @deliveries = @delivery_klass.printed
    render :action => "index"
  end
  
  def delivered
    @date = params[:date] ? params[:date].to_date : Date.today
    @delivery_klass = (current_user.admin? || current_user.employee?) ? Delivery : current_user.store.deliveries
    @deliveries = @delivery_klass.delivered
    render :action => "index"
  end
  
  def pending
    @date = params[:date] ? params[:date].to_date : Date.today
    @delivery_klass = (current_user.admin? || current_user.employee?) ? Delivery : current_user.store.deliveries
    @deliveries = @delivery_klass.pending
    render :action => "index"
  end
  
  def canceled
    @date = params[:date] ? params[:date].to_date : Date.today
    @delivery_klass = (current_user.admin? || current_user.employee?) ? Delivery : current_user.store.deliveries
    @deliveries = @delivery_klass.canceled
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
       @map.control_init(:large_map => false,:map_type => true)
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
    if params[:delivery_ids]
      @deliveries = Delivery.find(params[:delivery_ids])
    else
      @deliveries = Delivery.pending.by_date
    end
    @items = @deliveries.map(&:items)
    @donut_count, @roll_count, @donuthole_count = 0
    @deliveries = @deliveries.sort_by{|delivery| delivery.store.position }
    @deliveries.map do |delivery|
      @donut_count = (@donut_count + delivery.donut_count)
      @roll_count = (@roll_count + delivery.roll_count)
      @donut_hole_count = (@donut_hole_count + delivery.donut_hole_count)
      delivery.print!
    end
    render :layout => false
  end
  
  def generate_todays
    Store.all_by_position.each do |store|
      store.create_todays_delivery!
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

  def prompt_for_store_if_needed
    if @current_user && !@current_user.admin? && @current_user.customer? && @current_user.store.nil?
      flash[:warning] = "Please create your store first"
      redirect_to new_user_store_path(current_user)
    end
  end
  
  def find_delivery_with_item
    @delivery = Delivery.find(params[:id])
    @item = Item.available.find(params[:item_id])
  end
end
