class DeliveriesController < ApplicationController  
  before_filter :login_required
  before_filter :current_user_session
  before_filter :redirect_to_admin_if_needed
  before_filter :detect_date_and_delivery_class, :only => Delivery.aasm_states.map(&:name)
  before_filter :find_store, :only => [:index, :show]
  before_filter :set_current_date, :only => [:index]
  before_filter :ensure_user_has_store

  auto_complete_for :item, :name
  auto_complete_for :item, :item_type
  
  #caches_page :index, :expire => [:create, :update, :destroy], :if => Proc.new{ |c| c.request.format.json? }
  
  def index
    @store = current_user.store
    params[:status] ||= params[:action] unless params[:action] == "index"
    options = {:include => [:store], 
      :limit => (params[:limit]), :offset => (params[:start] || 0), :order => "id DESC"}
    
    @deliveries = params[:status] ? @store.deliveries.send(params[:status].to_sym).all(options) : @store.deliveries.all(options)
    @delivery_klass = @store.deliveries
  
    respond_to do |format|
      format.html
      format.xml{ render :xml => @deliveries.to_xml(:include => [:store]) }
      format.json{ render :json => deliveries_json_grid_fields(@deliveries, @delivery_klass.count) } 
    end
  end
      
  def show
    @delivery = @store.deliveries.find(params[:id], :include => [{:line_items, :item}])
     respond_to do |format|
       format.json{ render :json => deliveries_json_grid_fields([@delivery], 1) }
       format.html
       format.pdf{ render :layout => false }
     end
  end
  
  def new
    @delivery = Delivery.new
    @delivery.add_items
  end
  
  # TODO, clean this up
  def create
    line_items = params[:delivery].has_key?(:line_items) ? params[:delivery].delete(:line_items) : []
    @delivery = Delivery.new(params[:delivery])
    @delivery.comments.build(params[:comment]) if params[:comment] && !params[:comment][:body].blank?
    line_items.each{ |l| @delivery.line_items.build(l) } unless line_items.empty?
    if @delivery.save
      flash[:notice] = "Successfully created delivery."
      if @delivery.print_after_save
        redirect_to delivery_path(@delivery, :format => :pdf)
      else
        redirect_to @delivery
      end
    else
      render :action => 'new'
    end
  end
  
  def edit
    begin
      @delivery = Delivery.find(params[:id], :include => :store)
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "No delivery was found with the id #{params[:id]}"
      redirect_back_or_default(deliveries_path)
    end
  end
  
  def fetch
    @delivery = Delivery.find(params[:delivery_id], :include => :store)
    render :action => "edit"
  end
  
  def update
    @delivery = Delivery.find(params[:id])
    line_items = params[:delivery].delete(:line_items) || []
    if @delivery.update_attributes(params[:delivery]) && @delivery.update_line_items(line_items)
      flash[:notice] = "Successfully updated delivery."
      if @delivery.print_after_save
        redirect_to delivery_path(@delivery, :format => :pdf)
      else
        redirect_to @delivery
      end
    else
      render :action => 'edit'
    end
  end
    
  def filtered
    @deliveries = @delivery_klass.send(:"#{action_name}")
    render :action => "index"
  end
  
  Delivery.aasm_states.map(&:name).each do |state|
    alias_method state, :filtered
  end
        
  def destroy
    @delivery = Delivery.find(params[:id])
    @delivery.destroy
    flash[:notice] = "Successfully destroyed delivery."
    redirect_to deliveries_url
  end
  
  def search
    @delivery = Delivery.find(params[:id])
    respond_to do |format|
      format.html
      format.js{
        render :update do |page|
          if !@delivery.nil?
            page.replace_html(:deliveries, "")
            page.insert_html(:top, :deliveries, :partial => @delivery)
          else
            page.replace_html(:error, "No delivery found with that id.")
          end
        end
      }
    end
  end
  
  protected
  
  def deliveries_json_grid_fields(deliveries, count = nil)
    render_to_string(:partial => "grid_row", 
      :locals => {:deliveries => deliveries, :count => (count || deliveries.size)} )
  end

  # Returns the ActiveRecord collection or NamedScopeCollection
  # Example:
  #   deliveries_from_status(@store.deliveries, :pending) # => @store.deliveries.pending 
  def deliveries_from_status(klass, status = :all)
    if klass.respond_to?(status.to_sym)
      klass.send(status.to_sym)
    else
      Delivery.all # default
    end
  end

  # Sets an instance variable @date for the calendar features.
  # You need to add a before_filter for any action using the calendar.
  # before_filter :set_current_date, :only => [:index, :all, :history]
  def set_current_date
    @date = params[:date] ? Date.parse(params[:date]) : Time.zone.now
  end

  def detect_date_and_delivery_class
    @date = params[:date] ? params[:date].to_date : Date.today
    @delivery_klass = current_user.store.deliveries
  end
  
  def redirect_to_admin_if_needed
    if current_user.system_user?
      redirect_to admin_deliveries_path
      return
    end
  end
end
