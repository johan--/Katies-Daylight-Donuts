class Admin::CollectionsController < ApplicationController
  before_filter :login_required
  before_filter :admin_role_required
  before_filter :load_deliveries, :only => [:index]
  
  layout "admin"
  
  def index
    @collections = Collection.find(:all, :include => [:deliveries])
    respond_to do |format|
      format.html
      format.json{ render :json => {:collections => @collections.to_json, :totalCount => @collections.size} } 
    end
  end
   
  def destroy
    @collection = Collection.find(params[:id], :include => [:deliveries])
    if @collection.destroy
      success "Successfully Rolled Back Collection."
    else
      fail "Error: Could not Rollback Collection"
    end

    render :update do |page|
      if flash[:warning]
        message = flash[:warning]
      else
        page.remove(:"collection_#{params[:id]}")
        message = flash[:notice]
      end

      page << "facebox.reveal('#{message}', 'status-message')"
    end
  end
end
