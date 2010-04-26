require 'spec_helper'

module MailerSpecHelper
  private
  
  def read_fixture(controller, action)
    IO.readlines("#{File.dirname(__FILE__)}/fixtures/mailers/#{controller}/#{action}")
  end
end