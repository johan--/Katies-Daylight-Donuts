class DeliveryPresetsController < ApplicationController
  def index
    @delivery_presets = DeliveryPreset.all
  end
  
  def show
    @delivery_preset = DeliveryPreset.find(params[:id])
  end
  
  def new
    @delivery_preset = DeliveryPreset.new
  end
  
  def create
    @delivery_preset = DeliveryPreset.new(params[:delivery_preset])
    if @delivery_preset.save
      flash[:notice] = "Successfully created deliverypreset."
      redirect_to @delivery_preset
    else
      render :action => 'new'
    end
  end
  
  def edit
    @delivery_preset = DeliveryPreset.find(params[:id])
  end
  
  def update
    @delivery_preset = DeliveryPreset.find(params[:id])
    if @delivery_preset.update_attributes(params[:delivery_preset])
      flash[:notice] = "Successfully updated deliverypreset."
      redirect_to @delivery_preset
    else
      render :action => 'edit'
    end
  end
  
  def add_item
    @delivery_preset = DeliveryPreset.find(params[:id])
    line_item = @delivery_preset.line_items.build
    render :update do |page|
      page.insert_html(:bottom, :line_items, :partial => "line_item", :object => line_item)
    end
  end
  
  def remove_item
    @delivery_preset = DeliveryPreset.find(params[:id])
    if item = @delivery_preset.line_items.find(params[:item_id])
      if item.destroy
        flash[:notice] = "Successfully removed the item from this preset."
      else
        flash[:warning] = "Failed to save preset, and error occured."
      end
    else
      flash[:warning] = "Could not remove item from preset, an error occured."
    end
    redirect_to edit_store_delivery_preset_path(@delivery_preset)
  end
  
  def destroy
    @delivery_preset = DeliveryPreset.find(params[:id])
    @delivery_preset.destroy
    flash[:notice] = "Successfully destroyed deliverypreset."
    redirect_to delivery_presets_url
  end
end
