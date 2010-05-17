class Admin::PositionsController < ApplicationController
  before_filter :login_required
  before_filter :admin_role_required
  
  layout "admin"
  
  def index
    @positions = Position.all
  end
  
  def show
    @position = Position.find(params[:id])
  end
  
  def new
    @position = Position.new
    respond_to do |format|
      format.html
      format.js{ render :layout => false }
    end
  end
  
  def create
    @position = Position.new(params[:position])
    if @position.save
      flash[:notice] = "Successfully created position."
    else
      flash[:warning] = "Could not create the position"
    end
    
    respond_to do |format|
      format.html
      format.js{ 
        render :update do |page|
          page << "facebox.close()"
          page.insert_html(:top, :positions, :partial => @position)
        end
      }
    end
  end
  
  def edit
    @position = Position.find(params[:id])
  end
  
  def update
    @position = Position.find(params[:id])
    if @position.update_attributes(params[:position])
      flash[:notice] = "Successfully updated position."
      redirect_to [:admin, @position]
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @position = Position.find(params[:id])
    @position.destroy
    flash[:notice] = "Successfully destroyed position."
    redirect_to positions_url
  end
end
