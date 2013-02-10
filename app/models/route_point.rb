class RoutePoint < ActiveRecord::Base
  belongs_to :poi
  attr_accessible :elevation, :latitude, :longitude
end
