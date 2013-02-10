class Rating < ActiveRecord::Base
  belongs_to :poi
  belongs_to :user
  attr_accessible :comment, :ip, :rating
end
