class ClockinTime < ActiveRecord::Base
  belongs_to :employee
  
  named_scope :clocked_in, :conditions => {:ends_at => nil}, :limit => 1
  named_scope :clocked_out, :conditions => "starts_at is not NULL and ends_at is not NULL"
  
  attr_accessor :clockin_id
end
