class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  def self.admin
    @admin ||= find_by_name("admin")
  end
  
  def self.employee
    @employee ||= find_by_name("employee")
  end
  
  def self.customer
    @customer ||= find_by_name("customer")
  end
end
