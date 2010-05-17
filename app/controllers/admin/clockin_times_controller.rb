class Admin::ClockinTimesController < ApplicationController
  before_filter :login_required
  before_filter :admin_role_required

  layout "external"
  
  def new
    @clockin_time = ClockinTime.new
    @clockin_times = ClockinTime.current
  end
  
  def clockout
    @clockin_time = ClockinTime.find_by_employee_id(params[:id])
    render :action => :show
  end
  
  def create
    @employee = Employee.find_by_clockin_id(params[:clockin_time][:clockin_id])
    if @employee && !@employee.clocked_in? && @employee.clockin!
      flash[:notice] = "Thanks for clocking in, now go get em tiger!"
      render :update do |page|
        page.insert_html(:top, :employees, "<li>#{@employee.fullname} Since: Just now. <a href='/admin/timeclock/clockout/#{@employee.clockin_id}'>clockout</a></li>")
        page.replace_html(:message, flash[:notice])
        page << %($('message').removeClassName('warning'))
        page << %($('message').addClassName('notice'))
        page.visual_effect(:appear, :message, {:duration => 1})
        page.visual_effect(:fade, :message, {:duration => 4})
      end
    else
      if @employee.nil?
        msg = "I couldn't find any user with that clockin id." 
      elsif @employee.clocked_in?
        msg = "You are already clocked in, nice try."
      else
        msg = "An error occured. Please let someone know."
      end
      render :update do |page|
        page.replace_html(:message, msg)
        page << %($('message').removeClassName('notice'))
        page << %($('message').addClassName('warning'))
        page.visual_effect(:appear, :message, {:duration => 1})
        page.visual_effect(:fade, :message, {:duration => 4})
      end
    end
  end
  
  def destroy
    @clockin_time = ClockinTime.find_by_employee_id(params[:id], :include => [:employee])
    if @clockin_time && @clockin_time.employee.clockin_id == params[:employee_clockin_id]
      @clockin_time.employee.clockout!
      flash[:notice] = "You have been clocked out"
      redirect_to "/admin/timeclock"
    else
      flash[:notice] = "Sorry, the clockin id you provided does not belong to you."
      render :action => "show"
    end
  end
end
