class Admin::SmsController < ApplicationController
  before_filter :login_required
  before_filter :admin_role_required

  layout "admin"
  
  def index
    @sms_messages = Api::Sms.all
  end

  def new
    @sms_message = Api::Sms.new
  end
  
  def show
    @sms_message = Api::Sms.find(params[:id])
  end

  def create
    @sms_message = Api::Sms.new(params[:api_sms])
    if @sms_message.save
      @sms_message.deliver!
      flash[:notice] = "Successfully created SMS message."
      redirect_to admin_sms_path
    else
      flash[:warning] = "Could not save SMS message."
      render :action => "new"
    end
  end

end
