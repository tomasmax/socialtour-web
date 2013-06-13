class Poi < ActiveRecord::Base
  extend FriendlyId
  
  belongs_to :user
  belongs_to :city
  belongs_to :subcategory
  belongs_to :category
  belongs_to :supercategory
  
  has_many :photos, dependent: :delete_all
  has_many :events, dependent: :delete_all
  has_many :ratings, dependent: :delete_all
  has_many :comments, dependent: :delete_all
  has_many :route_infos, dependent: :delete_all
  has_many :route_points, dependent: :delete_all
 
  attr_accessible :user_id, :category_id, :supercategory_id,
                  :address, :description, :description_eu, :latitude, :longitude, 
                  :minube_id, :minube_url, :name, :name_eu, :rating, :ratings_count, :slug, 
                  :telephone, :timetable, :website,:foursquare_id, :foursquare_url, :checkins_count, 
                  :users_count, :tip_count, :likes_count,:city_id, :subcategory_id, :gpx_file
               
  attr_accessor :route_points_list
  attr_accessor :gpx_file
  attr_accessor :index
  
  reverse_geocoded_by :latitude, :longitude
  
  after_validation :reverse_geocode, :set_location, :if => :latitude_changed?
  
  friendly_id :name, use: :slugged
  
  validates :name, presence: true
  
  validates_uniqueness_of :name, :slug
  
  paginates_per 10
  
  #after_save :save_route, :generate_route_info
  after_commit :save_gpx_file,      if: :gpx_file
  after_commit :save_route_points,  if: :route_points_list
  before_save :set_supercategory
  
  def set_location
    results = Geocoder.search("#{self.latitude}, #{self.longitude}")
    if geo = results.first
      city = City.find_or_create_by_name(geo.city)
      self.city = city
    end
  end
  
  def set_supercategory
    if !self.supercategory_id && self.category
      self.supercategory_id = self.category.supercategory_id
    end
  end
  
  def localized_description(locale)
    if (locale == 'eu' || locale == 'eu_ES') && self.description_eu && self.description_eu.length > 0
      self.description_eu
    else
      self.description
    end
  end
  
  def localized_name(locale)
    if (locale == 'eu' || locale == 'eu_ES') && self.name_eu && self.name_eu.length > 0
      self.name_eu
    else
      self.name
    end
  end
  
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:category, :supercategory, :last_photos, :next_events, :route_info, :route_points_list, :index])
    super options
  end
  
  def next_events
    events.where('ends_at > ?', Time.now).order('starts_at asc').limit(10)
  end
  
  def last_photos
    photos.order('created_at desc').limit(10)
  end
  
  #routes methods
  def self.create_from_gpx(gpx)
    routes = []
    routes.push(*gpx.tracks)
    routes.push(*gpx.routes)
    
    routes.collect do |route|
      poi = create!(title: route.name, description: route.name, latitude: route.points.first.lat, longitude: route.points.first.lon)
      route.points.each {|p| poi.route_points.create(latitude: p.lat, longitude: p.lon, elevation: p.elevation) }
      poi
    end
  end
  
  def save_gpx_file
    gpx = GPX::GPXFile.new gpx_file: self.gpx_file.tempfile.path
    
    route   = gpx.tracks.first if gpx.tracks.any?
    route ||= gpx.routes.first if gpx.routes.any?
    
    raise "No routes found in GPX file" if !route
    
    latitude = route.points.first.lat
    longitude = route.points.first.lon
    route.points.each {|p| route_points.create(latitude: p.lat, longitude: p.lon, elevation: p.elevation) }
    
    self.gpx_file = nil
    save
    create_route_info unless route_info
  end
  
  def save_route_points
    route_points_list.each {|i, point| point ||= i; route_points.create(point) }
    
    self.route_points_list = nil
    create_route_info unless route_info
  end
  
end
