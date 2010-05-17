class Admin::ItemsController < ApplicationController
  before_filter :login_required
  before_filter :admin_role_required
  auto_complete_for :item, :name
  
  layout "admin"
  
  def index
    @items = Item.all(:order => "available desc")
  end
  
  def show
    @item = Item.find(params[:id])
  end
  
  def new
    @item = Item.new
  end
  
  def create
    @item = Item.new(params[:item])
    if @item.save
      flash[:notice] = "Successfully created item."
      redirect_to [:admin, @item]
    else
      render :action => 'new'
    end
  end
  
  def edit
    @item = Item.find(params[:id])
  end
  
  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      flash[:notice] = "Successfully updated item."
      redirect_to [:admin, @item]
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed item."
    redirect_to admin_items_url
  end
  
  def screen_calculation
    @screen_calculation = ScreenCalculation.new(params)
    render :update do |page|
      page.replace_html(:screen_calculation, @screen_calculation.to_html)
      page.show(:screen_calculation)
    end
  end
end
