class Poi < ActiveRecord::Base
  extend FriendlyId
  
  belongs_to :user
  belongs_to :city
  belongs_to :category
  belongs_to :supercategory
  
  has_many :photos, dependent: :delete_all
  has_many :events, dependent: :delete_all
  has_many :ratings, dependent: :delete_all
  has_many :route_infos, dependent: :delete_all
  has_many :route_points, dependent: :delete_all
  
  attr_accessible :user_id, :category_id, :supercategory_id,
                  :address, :description, :description_eu, :latitude, :longitude, 
                  :minube_id, :minube_url, :name, :name_eu, :rating, :ratings_count, :slug, 
                  :telephone, :timetable, :website,:foursquare_id, :foursquare_url, :checkins_count, 
                  :users_count, :tip_count, :likes_count,:city_id

                  
  attr_accessor :route_points_list
  attr_accessor :gpx_file
  attr_accessor :index
  
  friendly_id :name, use: :slugged
  
  validates :name, presence: true
  #validates :slug, presence: true
  
  validates_uniqueness_of :name, :slug, :minube_id
  
  paginates_per 10
  
  #after_save :save_route, :generate_route_info
  before_save :set_supercategory
  
  
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
  
  #metodos de las rutas
  def generate_route_info
    if !self.route_info && self.route_points && self.route_points.count > 0
      self.create_route_info
    end
  end
  
  def save_route
    if self.gpx_file
      self.save_gpx_file
    else
      self.save_route_points
    end
  end
  
  def save_gpx_file
    gpx = GPX::GPXFile.new gpx_file: self.gpx_file.tempfile.path
    
    if gpx.tracks
      self.latitude = gpx.tracks.first.points.first.lat
      self.longitude = gpx.tracks.first.points.first.lon
      gpx.tracks.first.points.each do |route_point|
        self.route_points.new(latitude: route_point.lat, longitude: route_point.lon, elevation: route_point.elevation).save!
      end
    elsif gpx.routes
      self.latitude = gpx.routes.first.points.first.lat
      self.longitude = gpx.routes.first.points.first.lon
      gpx.routes.first.points.each do |route_point|
        self.route_points.new(latitude: route_point.lat, longitude: route_point.lon, elevation: route_point.elevation).save!
      end
    end
    self.gpx_file = nil
    self.save
  end
  
  def save_route_points
    if @route_points_list
      if @route_points_list.kind_of?(Array)
        @route_points_list.each do |route_point| 
          self.route_points.new(route_point).save
        end
      else
        @route_points_list.each do |index, route_point| 
          self.route_points.new(route_point).save
        end
      end
    end
  end
  
end
