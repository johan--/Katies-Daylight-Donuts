class EmployeesController < ApplicationController
  before_filter :login_required
  
  def index
    # @employees = Employee.paginate_by_creation params.dup
    @employees = Employee.all
    respond_to do |format|
      format.html
      format.js{ render :partial => "employee_list" }
    end
  end
  
  def show
    @employee = Employee.find(params[:id])
  end
  
  def new
    @employee = Employee.new
  end
  
  def create
    @employee = Employee.new(params[:employee])
    @employee.positions << build_positions! if params[:position_names]
    if @employee.save
      flash[:notice] = "Successfully created employee."
      redirect_to @employee
    else
      render :action => 'new'
    end
  end
  
  def edit
    @employee = Employee.find(params[:id])
  end
  
  def update
    params[:employee][:position_ids] ||= []
    @employee = Employee.find(params[:id])
    if @employee.update_attributes(params[:employee])
      flash[:notice] = "Successfully updated employee."
      redirect_to @employee
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy
    flash[:notice] = "Successfully destroyed employee."
    redirect_to employees_url
  end
  
  def validate_clockin_id_available
    render :text => Employee.clockin_id_available?(params[:employee_clockin_id]) ? "Available" : "Unavailable"
  end
  
  def timesheet
    @employee = Employee.find(params[:id])
    @date = Time.parse("#{params[:start_date]} || Time.zone.now")
    @start_date = Date.new(@date.year, @date.month, @date.day)
    @events = @employee.hours.clocked_out.find(:all, :conditions => ['starts_at between ? and ?', @start_date, @start_date + 7])
  end
  
  private
  
  def build_positions!
    positions = []
    positions = Position.find(params[:position_ids]) if params.has_key?(:position_ids)
    params[:position_names].each do |name|
      p = Position.find_or_create_by_name(name)
      positions.push(p) if p and p.valid?
    end
    return positions.uniq
  end
end
