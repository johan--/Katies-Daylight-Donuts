class BuyBacksController < ApplicationController
  before_filter :login_required, :except => [:index, :search]
  before_filter :find_delivery, :except => [:index]
  before_filter :current_user_session
  
  def index
    @buy_backs = BuyBack.all
  end
  
  def show
    @buy_back = @delivery.buy_backs.find(params[:id])
  end
  
  def new
    @buy_back = @delivery.buy_backs.new
  end
  
  def create
    @buy_back = @delivery.buy_backs.new(params[:buy_back])
    if @buy_back.save
      flash[:notice] = "Successfully created buyback."
      redirect_to @buy_back.delivery
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
    @buy_back = @delivery.buy_backs.find(params[:id])
    @buy_back.destroy
    flash[:notice] = "Successfully destroyed buyback."
    redirect_to buy_backs_url
  end
  
  protected
  
  def find_delivery
    @delivery = Delivery.delivered.find(params[:delivery_id])
  end
end
