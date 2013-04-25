class CategoryFacebook < ActiveRecord::Base
  attr_accessible :name
  has_many :likes, :through => :like_categories
  has_many :like_categories
end
