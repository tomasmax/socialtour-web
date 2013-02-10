class Poi < ActiveRecord::Base
  belongs_to :user
  belongs_to :city
  belongs_to :category
  belongs_to :supercategory
  
  has_many :photos, dependent: :delete_all
  has_many :events, dependent: :delete_all
  has_many :ratings, dependent: :delete_all
  
  attr_accessible :address, :description, :description_eu, :latitude, :longitude, :minube_id, :minube_url, :name, :name_eu, :picture_nomral, :picture_thumbnail, :rating, :ratings_count, :slug, :telephone, :timetable, :website
  
  attr_accessor :route_points_list
  attr_accessor :gpx_file
  
  validates :title, presence: true
  validates :slug, presence: true
  
  validates_uniqueness_of :title, :slug, :minube_id
  
  paginates_per 10
  
  before_validation :generate_slug
  #after_save :save_route, :generate_route_info
  before_save :set_supercategory
   
  def generate_slug
    if !self.slug
      self.slug = self.title.without_accents.to_slug
    end
  end
  
  def set_supercategory
    if !self.supercategory_id && self.category
      self.supercategory_id = self.category.supercategory_id
    end
  end
  
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:category, :supercategory, :last_photos, :next_events, :route_info, :route_points_list])
    super options
  end
  
  def next_events
    events.where('ends_at > ?', Time.now).order('starts_at asc').limit(10)
  end
  
  def last_photos
    photos.order('created_at desc').limit(10)
  end
  
  #metodos de las rutas
=begin
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
=end
  
end
