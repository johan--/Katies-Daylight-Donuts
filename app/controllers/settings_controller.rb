class SettingsController < ApplicationController
  before_filter :login_required
  before_filter :load_setting_record
  before_filter :load_setting, :except => [:edit, :update]
  
  def update
    if @setting.update_attributes(params[:setting])
      flash[:notice] = "Successfully updated setting."
      redirect_to @setting
    else
      render :action => 'edit'
    end
  end

  protected
  
  def load_setting_record
    @setting = Setting.for_application
  end
  
  def load_setting
    load_setting_record
    render :action => "edit"
  end
  
end
