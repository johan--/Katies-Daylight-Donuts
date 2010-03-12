class Company < ActiveRecord::Base
  has_many :stores, :dependent => :destroy
end
