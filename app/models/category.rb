class Category < ActiveRecord::Base
  belongs_to :supercategory
  has_many :pois
  attr_accessible :description, :group, :is_route, :name, :slug
end
