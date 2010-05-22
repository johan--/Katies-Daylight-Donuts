class Api::SmsController < ApplicationController  
  before_filter :login_required, :only => [:index, :outgoing]

  protect_from_forgery :except => :incoming

  def incoming
    if params[:uid]
      # subscribed user message
      user = User.find(params[:uid]) || User.nobody
      @message = Api::Sms.new(:user => user, :prefix => params[:sms_prefix],:body => params[:body])
    else
      # unsubscribed user
      @message = Api::Sms.new(:user => User.nobody, :prefix => params[:sms_prefix], :body => params[:body])
    end
    
    render :status => @message.save ? 200 : 500, :text => "Success", :content_type => "text/plain"
  end

  def outgoing
    response = Zeep::Messaging.send_message(params[:user_id], params[:body])
    if response.code.to_i == 200
      render :json => {:code => 200, :body => response.body}
    else
      render :status => response.code.to_i, :text => response.body, :content_type => "text/plain"
    end
  end

end