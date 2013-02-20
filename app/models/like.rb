class Like < ActiveRecord::Base
  attr_accessible :category, :created_time, :facebook_id, :name, :user_id
  belongs_to :user
end
