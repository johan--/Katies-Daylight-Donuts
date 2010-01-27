class EmployeeObserver < ActiveRecord::Observer
  def after_create(employee)
    UserNotifier.deliver_new_employee_notification(Setting.email, employee)
  end
end
