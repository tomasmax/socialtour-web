class City < ActiveRecord::Base
  extend FriendlyId
  has_attached_file :image, styles: { city: "200x100#" }, 
    url: "/cities_img/:hash.:extension",
    hash_secret: "7L!R1T)_<)5^1/2k_.##5|!+;&)%T;"
    
  belongs_to :country
  belongs_to :zone
  has_many :users
  has_many :pois
  has_many :events
  attr_accessible :icon_content_type, :icon_file_name, :icon_file_size, :icon_update_at, :name, :name_eu, :slug, :minube_id, :image,
                  :latitude, :longitude, :zone_id
                  
  geocoded_by :name
  
  after_validation :geocode, :set_location, :if => :name_changed?
   
  #validates :slug, :presence => true
  validates_uniqueness_of :slug
  
  friendly_id :name, use: :slugged
  #before_validation :generate_slug
  
  def set_location
    results = Geocoder.search(self.name)
    if geo = results.first
      self.latitude = geo.latitude
      self.longitude = geo.longitude
      zone = Zone.find_or_create_by_name(geo.province)
      self.zone = zone
      country = Country.find_or_create_by_name(geo.country)
      self.country = country
    end
  end
  
  def generate_slug
    if !self.slug
      self.slug = self.name.to_slug
    end
  end
  
end
