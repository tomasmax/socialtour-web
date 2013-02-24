class Type < ActiveRecord::Base
  has_many :packages
  
  attr_accessible :description, :type
end
