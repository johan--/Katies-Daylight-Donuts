class SchedulesController < ApplicationController
  before_filter :login_required
  before_filter :admin_role_required, :except => [:show]
  before_filter :set_date
  
  def index
    @date = params[:date] ? Date.parse(params[:date]) : Time.zone.today
    @schedules = Schedule.by_date(@date)
  end
  
  def new
    @date = Date.parse(params[:date])
    @schedule = Schedule.new(:work_date => (params[:date] || Time.zone.now))
    respond_to do |format|
      format.html
      format.js{ render :layout => false }
    end
  end
  
  def edit
    @schedule = Schedule.find(params[:id])
    @date = @schedule.work_date
    respond_to do |format|
      format.html
      format.js{ render :layout => false }
    end
  end
  
  def show
    @schedule = Schedule.find(params[:id])
    @employee = @schedule.employee
    @this_weeks_schedules = @employee.schedules.for_this_week
    @total_hours = @this_weeks_schedules.compact.map(&:total_hours).sum
    respond_to do |format|
      format.html
      format.pdf{ 
        prawnto :inline => false, :filename => "#{@employee.fullname}'s-schedule.pdf"
        render :layout => false
      }
    end
  end
  
  def create
    @schedule = Schedule.new(params[:schedule])
    if @schedule.save
      flash[:notice] = "Schedule was saved"
    else
      flash[:warning] = "Schedule could not be saved"
    end
    respond_to do |format|
      format.html{ @schedule.valid? ? redirect_to(@schedule) : render(:action => "new") }
      format.js{
        render :update do |page|
          page.insert_html(:top, :schedules, :partial => @schedule, :locals => {:row_class => cycle("oddRow","stripe")})
          page << "stripe()" 
        end
      }
    end
  end
  
  def update
    @schedule = Schedule.find(params[:id])
    @schedule.update_attributes(params[:schedule])
    if @schedule.save
      flash[:notice] = "Schedule was updated"
    else
      flash[:warning] = "Schedule could not be upated"
    end
    respond_to do |format|
      format.html{ @schedule.valid? ? redirect_to(@schedule) : render(:action => "edit") }
      format.js{
        render :update do |page|
          page.replace_html(:schedules, :partial => Schedule.by_date(@schedule.work_date))
          page << "facebox.close()"
        end
      }
    end
  end
  
  def destroy
    @schedule = Schedule.find(params[:id])
    current_date = @schedule.work_date.strftime("%Y-%m-%d")
    if @schedule.destroy
      flash[:notice] = "Successfully removed schedule"
    else
      flash[:warning] = "Failed to remove schedule"
    end
    redirect_to schedules_path(:date => current_date)
  end
  
  protected
  
  def set_date
    @date ||= Time.zone.today
  end
end
