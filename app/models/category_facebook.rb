class CategoryFacebook < ActiveRecord::Base
  attr_accessible :name
  has_many :likes, :through => :like_categories
end
