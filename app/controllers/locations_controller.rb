class LocationsController < ApplicationController
  def index
    @stores = Store.find(:all, :include => [:city])
    @cities = @stores.map(&:city_name).uniq
    respond_to do |format|
      format.html
      # format.json{ render :json => @stores }
    end
  end
  
  def search
    if params[:q].blank?
      @stores = Store.find(:all)
    else
      @stores = Store.find(:all, :conditions => ["zipcode like ?","%" + params[:q] + "%"])
    end
    render :update do |page|
      page.replace_html(:stores_list, :partial => "store", :collection => @stores)
      page.replace_html(:city_name, @stores.map(&:city_name).uniq.join(', ')) unless params[:q].blank?
    end
  end
  
end
