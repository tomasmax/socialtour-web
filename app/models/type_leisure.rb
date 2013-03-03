class TypeLeisure < ActiveRecord::Base
  has_many :packages
  
  attr_accessible :description, :name
end
