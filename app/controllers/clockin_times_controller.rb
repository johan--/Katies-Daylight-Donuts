class ClockinTimesController < ApplicationController
  before_filter :login_required
  
  def new
    @clockin_time = ClockinTime.new
  end
  
  def show
    @clockin_time = ClockinTime.find(params[:id])
  end
  
  def create
    @employee = Employee.find_by_clockin_id(params[:employee_id])
    clocked_in = !@employee.clocked_out?
    if params[:context] == "clockin" && !clocked_in && @employee.clockin!
      flash[:notice] = msg = "Successfully clocked in #{@employee.fullname}"
    elsif params[:context] == "clockout"  && clocked_in && @employee.clockout!
      flash[:notice] = msg = "Successfully clocked out #{@employee.fullname}"
    elsif @employee.nil?
      flash[:warning] = msg = "Invalid Clockin ID"
    else
      if clocked_in && params[:context] == "clockin"
        flash[:notice] = msg = "You are already clocked in"
      elsif !clocked_in && params[:context] == "clockout"
        flash[:notice] = msg = "You are already clocked out"
      end
    end
  
    render :update do |page|
      page.replace_html(:clockin_response, msg)
      page << "$('clockin_notification').onclick();"
    end
  end
end
