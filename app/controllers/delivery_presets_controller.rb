class DeliveryPresetsController < ApplicationController
  before_filter :login_required
  
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
      flash[:notice] = "Successfully Created Delivery."
      redirect_to edit_delivery_preset_path(@delivery_preset)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @delivery_preset = DeliveryPreset.find(params[:id])
  end
  
  def copy
    @delivery_preset = DeliveryPreset.find(params[:id])
    @copy_from_delivery_preset = DeliveryPreset.find(params[:copy_from_id])
    attributes = @copy_from_delivery_preset.attributes.dup
    attributes.delete(:id)
    attributes.delete(:day_of_week)
    if @delivery_preset.update_attributes(attributes)
      flash[:notice] = "Copy complete"
    else
      flash[:warning] = "Copy failed"
    end
    redirect_to edit_store_delivery_preset_path(@delivery_preset.store, @delivery_preset)
  end
  
  def update
    @delivery_preset = DeliveryPreset.find(params[:id])
    line_items = params[:delivery_preset].delete(:line_items)
    if @delivery_preset.update_attributes(params[:delivery_preset]) && @delivery_preset.update_line_items(line_items)
      flash[:notice] = "Successfully Updated Delivery Preset."
      redirect_to edit_delivery_preset_path(@delivery_preset)
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
