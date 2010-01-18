class DeliveriesController < ApplicationController
  before_filter :login_required, :except => [:index]
  
  def index
    if params[:status] == "pending"
      @deliveries = Delivery.pending
    elsif params[:status] == "delivered"
      @deliveries = Delivery.delivered
    else
      @deliveries = Delivery.all
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
  
  def destroy
    @delivery = Delivery.find(params[:id])
    @delivery.destroy
    flash[:notice] = "Successfully destroyed delivery."
    redirect_to deliveries_url
  end
end
