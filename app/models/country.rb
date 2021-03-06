class Country < ActiveRecord::Base
  has_many :cities
  has_many :zones
  
  attr_accessible :blog_count, :full_count, :hotel_count, :latitude, :longitude, :minube_id, :name, :pois_count, :restaurant_count, :see_count
end
