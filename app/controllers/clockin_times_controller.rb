class ClockinTimesController < ApplicationController
  before_filter :login_required
  
  def show
    @clockin_time = ClockinTime.find(params[:id])
  end
  
  def create
    @employee = Employee.find_by_clockin_id(params[:employee_id])
    if @employee && @employee.clocked_out?
      
      if @employee.clockin!
        # notice message
        flash[:notice] = msg = "Successfully clocked in #{@employee.fullname}"
      else
        # error message
        flash[:warning] = msg = "Clockin failure"
      end
    
    elsif @employee && @employee.clockout!
      flash[:notice] = msg = "Successfully clocked out #{@employee.fullname}"
    else
      # could not find employee
      flash[:warning] = msg = "Invalid clockin ID"
    end
    render :update do |page|
      page.replace_html(:clockin_response, msg)
      page << "$('clockin_notification').onclick();"
    end
  end
end
