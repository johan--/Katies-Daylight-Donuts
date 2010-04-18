class BuyBacksController < ApplicationController
  before_filter :login_required, :except => [:index, :search]
  before_filter :find_delivery, :except => [:index,:new]
  before_filter :current_user_session
  
  def index
    @buy_backs = BuyBack.paginate :page => params[:page], :order => "created_at DESC"
  end
  
  def show
    @buy_back = @delivery.nil? ? BuyBack.find(params[:id]) : @delivery.buy_backs.find(params[:id])
  end
  
  def new
    if params[:delivery_id]
      @delivery = Delivery.find(params[:delivery_id]) 
    else
      @delivery = Delivery.first
    end
    @buy_back = @delivery.buy_backs.new(:price => @delivery.total)
    respond_to do |format|
      format.html{ @buy_back.copy_delivery_line_items }
      format.js{
        if params[:delivery_id]
          render :update do |page|
            page.select("#buy_back_price").each do |field|
              field.value = @delivery.total
              page.visual_effect(:highlight, :buy_back_price)
            end
            page.replace_html(:line_items, :partial => "line_item", :collection => @buy_back.copy_delivery_line_items)
            page.visual_effect(:highlight, :line_items)
          end
        else
          render :layout => false
        end
      }
    end
  end
  
  def create
    line_items = params[:buy_back].delete(:line_items) || []
    @buy_back = @delivery.nil? ? BuyBack.new(params[:buy_back]) : @delivery.buy_backs.new(params[:buy_back])
    line_items.each{ |l| @buy_back.line_items.build(l) }
    if @buy_back.save
      flash[:notice] = "Successfully created buyback."
      redirect_to @buy_back
    else
      render :action => 'new'
    end
  end
  
  def edit
    @buy_back = @delivery.buy_backs.find(params[:id])
  end
  
  def update
    @buy_back = @delivery.buy_backs.find(params[:id])
    if @buy_back.update_attributes(params[:buy_back])
      flash[:notice] = "Successfully updated buyback."
      redirect_to @buy_back
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @buy_back = BuyBack.find(params[:id])
    @buy_back.destroy
    flash[:notice] = "Successfully destroyed buyback."
    redirect_to buy_backs_url
  end
  
  protected
  
  def find_delivery
    @delivery = Delivery.delivered.find(params[:delivery_id]) if params[:delivery_id]
  end
end
