class Rating < ActiveRecord::Base
  belongs_to :poi
  belongs_to :user
  belongs_to :package
  
  attr_accessible :comment, :ip, :rating
end
