require 'spec_helper'

describe ApplicationController do
  it "should render_optional_error_file" do
    get :foo
    response.should render_template("errors/404.html.erb")
    response.code.to_i.should == 404
  end
end