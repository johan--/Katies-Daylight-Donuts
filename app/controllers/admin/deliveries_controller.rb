class Admin::DeliveriesController < ApplicationController
  before_filter :login_required
  before_filter :admin_role_required
  
  layout "admin"
  
  def index
    @date = params[:date] || Time.zone.now
    @delivery_klass = Delivery
    scope = params[:status] ? @delivery_klass.send(params[:status].to_sym) : @delivery_klass
    @deliveries = scope.all(:include => [{:store,:route}], :order => "id desc", :limit => (params[:limit] || 70), :offset => (params[:start] || 0))
    respond_to do |format|
      format.html
      format.xml{ render :xml => @deliveries.to_xml(:include => [:store]) }
      format.json{ render :json => deliveries_json_grid_fields(@deliveries, @delivery_klass.count) } 
    end
  end
  
  def new
    @delivery = Delivery.new
  end
  
  # id - The Id of the delivery
  #
  def edit
    @delivery = Delivery.find(params[:id])
  end
  
  def show
    @delivery = Delivery.find(params[:id])
    respond_to do |format|
      format.html
      format.json{
        render :json => deliveries_json_grid_fields([@delivery], 1)
      }
      format.pdf{
         @deliveries = Delivery.pending.by_date
         @donut_count = @deliveries.map(&:donut_count).sum
         @roll_count = @deliveries.map(&:roll_count).sum
         @donut_hole_count = @deliveries.map(&:donut_hole_count).sum
         render :layout => false
       }
    end
  end
  
  def create
    @delivery = Delivery.new(params[:delivery])
    if @delivery.save
      success "Delivery was successfully created."
      redirect_to admin_deliveries_path
    else
      render :action => "new"
    end
  end
  
  def update
    @delivery = Delivery.find(params[:id])
    line_items = params[:delivery].delete(:line_items) || []
    if @delivery.update_attributes(params[:delivery]) && @delivery.update_line_items(line_items)
      success "Delivery was successfully updated."
      redirect_to admin_deliveries_path
    else
      fail "Delivery could not be updated."
      render :action => "edit"
    end
  end
  
  def destroy
    @delivery = Delivery.find(params[:id])
    if @delivery.destroy
      success "Delivery was successfully removed."
      redirect_to admin_deliveries_path
    else
      fail "Delivery could not be removed."
      redirect_back_or_default :index
    end
  end
  
  # Custom Actions
  
  def generate_todays
    Store.create_todays_deliveries!
    respond_to do |format|
      format.html{ redirect_to deliveries_path }
      format.js
    end
  end
  
  def print_todays
    @schedules = Schedule.for_today
    if params[:delivery_ids]
      @deliveries = Delivery.find(params[:delivery_ids])
    else
      @deliveries = Delivery.pending.by_date
    end
    if @deliveries.empty?
      fail "No deliveries to print, you could try generating them first."
      redirect_to deliveries_path
      return
    end
    @items = @deliveries.map(&:items)
    @deliveries = @deliveries.sort_by{|delivery| delivery.store.position }
    @donut_count = @deliveries.map(&:donut_count).sum
    @roll_count = @deliveries.map(&:roll_count).sum
    @donut_hole_count = @deliveries.map(&:donut_hole_count).sum
    @deliveries.map do |delivery|
      unless delivery.printed?
        delivery.print!
      end
    end unless params[:print] == false
    filename = "tickets-for-#{Time.zone.now.strftime('%m-%d-%Y')}.pdf"
    @collection = Collection.create(:name => filename,:deliveries => @deliveries) unless params[:print] == false
    prawnto :inline => false, :filename => filename
    render :layout => false
  end
  
  def filtered
    @deliveries = @delivery_klass.send(:"#{action_name}")
    render :action => "index"
  end
  
  Delivery.aasm_states.map(&:name).each do |state|
    alias_method state, :filtered
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
  
  protected
  
  def deliveries_json_grid_fields(deliveries, count = nil)
    render_to_string(:partial => "admin/deliveries/grid_row", 
      :locals => {:deliveries => deliveries, :count => (count || deliveries.size)} )
  end
end      