class RoutesController < ApplicationController
  before_filter :login_required
  before_filter :admin_role_required
  
  def new
    @route = Route.new
    respond_to do |format|
      format.html
      format.js{ render :layout => false }
    end
  end

  def edit
    @route = Route.find(params[:id])
  end
  
  def show
    @route = Route.find(params[:id])
    render :action => "edit"
  end

  def destroy
    @route = Route.find(params[:id])
    if @route.destroy
      flash[:notice] = "Route was successfully removed."
      redirect_back_or_default(stores_path)
    else
      flash[:warning] = "Route could not be removed."
      render :action => "show"
    end
  end

  def update
    @route = Route.find(params[:id])
    if @route.update_attributes(params[:route])
      flash[:notice] = "Route was successfully updated."
      redirect_back_or_default(stores_path)
    else
      flash[:warning] = "Route could not be saved."
      render :actioin => "edit"
    end
  end
  
  def add_store
    @store = Store.find(params[:store_id].to_i)
    @route = Route.find(params[:id])
    if @store && @route
      flash[:notice] = "Successfully added #{@store.name} to #{@route.name}" if @store.update_attribute(:route_id, @route.id)
    else
      flash[:warning] = "Could not add store to route."
    end
    
    respond_to do |format|
      format.html{ redirect_to routes_path }
      format.js{
        render :update do |page|
          if @store && @route
            page.replace_html(:"route_name_for_store#{@store.id}", @route.name)
            page.visual_effect(:highlight, :"route_#{@route.id}")
            page.visual_effect(:highlight, :"#{@store.id}_store_route_droppable")
          else
            page.replace_html(:flash_warning, flash[:warning])
          end
        end
      }
    end
  end

  def create
    @route = Route.new(params[:route])
    if @route.save
      flash[:notice] = "Route was created successfully."
      respond_to do |format|
        format.html{ redirect_back_or_default(stores_path) }
        format.js{ 
          render :update do |page|
            page.insert_html(:top, :routes, :partial => @route)
          end
        }
      end
    else
      flash[:warning] = "Route could not be created."
      render :action => "new"
    end
  end

end
