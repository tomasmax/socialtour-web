class LikeCategory < ActiveRecord::Base
  attr_accessible :category_facebook_id, :like_id
  belongs_to :like
  belongs_to :category_facebook
end
