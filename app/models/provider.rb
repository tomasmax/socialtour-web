class Provider < ActiveRecord::Base
  belongs_to :city
  belongs_to :category
  belongs_to :supercategory
  has_many :packages
  has_many :events
  attr_accessible :description, :name
end
