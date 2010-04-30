=begin
require 'spec_helper'
require 'mailer_spec_helper'

describe UserNotifier do
  include MailerSpecHelper
  include ActionMailer::Quoting
  
  before(:each) do
    @expected = TMail::Mail.new
    @expected.set_content_type 'text', 'plain', { 'charset' => 'UTF-8' }
    @expected.mime_version = '1.0'
    @user = Factory.create(:user)
  end
  

  it 'should send new delivery notification' do
    @expected.subject = 'New Delivery'
    @expected.body = read_fixture("user_notifiers", "new_delivery_notification")
    @expected.from = "noreply@katiesdaylightdonuts.com"
    @expected.to = @user.email
    @delivery = Factory.create(:delivery)
    UserNotifier.deliver_new_delivery_notification(@user, @delivery).encoded.should == @expected.encoded
  end

end
=end