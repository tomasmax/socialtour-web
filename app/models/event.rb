class Event < ActiveRecord::Base
  belongs_to :category
  belongs_to :poi
  belongs_to :city
  belongs_to :provider
  attr_accessible :description, :ends_at, :name, :picture, :price, :references, :start_time, :starts_at, :supercategory, :url, :city_id, :poi_id,
                  :latitude, :longitude, :category_id, :provider_id, :name_eu, :description_eu, :timetable, :place, :buy_ticket_url
  
  validates_presence_of :starts_at
  validates_presence_of :ends_at
  
  #reverse_geocoded_by :latitude, :longitude
  
  #before_save :set_supercategory
  
  after_validation :set_location, :if => :latitude_changed?
  
  def set_location
    results = Geocoder.search("#{self.latitude}, #{self.longitude}")
    if geo = results.first
      city = City.find_or_create_by_name(geo.city)
      self.city = city
    end
    poi = Poi.find_by_longitude_and_latitude(self.longitude, self.latitude)
    if poi
      self.poi = poi
    end
  end
  
  def set_supercategory
    if !self.supercategory_id && self.category
      self.supercategory_id = self.category.supercategory_id
    end
  end
  
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:poi_slug, :poi_name])
    super options
  end
  
  def poi_slug
    poi.slug
  end
  
  def poi_name
    poi.name
  end
  
end
