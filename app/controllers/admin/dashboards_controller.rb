class Admin::DashboardsController < ApplicationController
  before_filter :login_required
  before_filter :admin_role_required
  
  layout "admin"
  
  def index
    @models = [Delivery,BuyBack,Employee,Item,Store]
    @dashboard = Dashboard.new
  end
  
  def exports
    @models = [Delivery,BuyBack,Employee,Item,Store]
  end
  
  def export
    @payload = []
    params.each do |name, values|
      if [:delivery,:buy_back,:employee,:item,:store].include?(name.to_sym)
        klass = name.titleize.gsub(/ /,'').constantize
        exportable = values.map{|k,v| k.to_s if v != "0" }.compact
        @payload << klass.find(:all, :select => exportable.join(",")) unless exportable.empty?     
      end
    end
    render params[:format].to_sym => @payload.flatten
  end
end
