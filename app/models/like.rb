class Like < ActiveRecord::Base
  attr_accessible :category, :created_time, :facebook_id, :name, :user_id
  belongs_to :user
  has_many :category_facebooks, :through => :like_categories
  has_many :like_categories
end
