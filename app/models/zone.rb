class Zone < ActiveRecord::Base
  belongs_to :country
  attr_accessible :latitude, :longitude, :name
  
  geocoded_by :name
 
  after_validation :geocode, :if => :name_changed?
 
  
  def set_location
    results = Geocoder.search(self.name)
    if geo = results.first
      self.latitude = geo.latitude
      self.longitude = geo.longitude
      country = Country.find_or_create_by_name(geo.country)
      self.country = country
    end
  end
  
end
