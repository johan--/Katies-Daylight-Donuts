class SettingsController < ApplicationController
  before_filter :login_required
  before_filter :load_setting_record
  before_filter :admin_role_required
  
  def update
    @setting = Setting.for_application
    if @setting.update_attributes(params[:setting])
      flash[:notice] = "Successfully updated setting."
      respond_to do |format|
        format.html{ redirect_to @setting }
        format.js{ render :nothing => true }
      end
    else
      render :action => 'edit'
    end
  end
  
  def edit
    @setting = Setting.for_application
    respond_to do |format|
      format.html
      format.js{ render :layout => false }
    end
  end

  protected
  
  def load_setting_record
    @setting = Setting.for_application unless defined?(@setting)
  end
end
