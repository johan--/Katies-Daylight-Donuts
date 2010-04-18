class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  def self.admin
    @admin ||= find_or_create_by_name("admin")
  end
  
  def self.employee
    @employee ||= find_or_create_by_name("employee")
  end
  
  def self.customer
    @customer ||= find_or_create_by_name("customer")
  end
end
