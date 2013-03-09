class Event < ActiveRecord::Base
  belongs_to :category
  belongs_to :poi
  belongs_to :city
  belongs_to :provider
  attr_accessible :description, :ends_at, :name, :picture, :price, :references, :start_time, :starts_at, :supercategory, :url, :city_id, :poi_id,
                  :latitude, :longitude
  
  validates_presence_of :starts_at
  validates_presence_of :ends_at
  
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      city = City.find_or_create_by_name(geo.city)
      self.city = city
    end
  end
  
  after_validation :reverse_geocode
  
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
