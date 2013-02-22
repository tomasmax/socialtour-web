class Supercategory < ActiveRecord::Base
  has_attached_file :icon, styles: { small: '32x32>', med: '64x64>', big: '128x128>' }, 
    url: "/supercategory_img/:hash.:extension",
    hash_secret: "^{R8'PHwe$Jrx@(%rvbo38q"
  
  attr_accessible :icon_content_type, :icon_file_name, :icon_file_size, :icon_update_at, :name, :slug, :icon,
                  :foursquare_id, :foursquare_icon, :name_eu, :name_en
    
  has_many :categories
  has_many :pois
  
  validates :name, :presence => true
  validates :slug, :presence => true
  validates_uniqueness_of :slug
  
  before_validation :generate_slug
  
  def generate_slug
    if !self.slug
      self.slug = self.name.without_accents.to_slug
    end
  end
  
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:icon_urls])
    super options
  end
  
  def icon_urls
    { 
      small: self.icon.url(:small),
      med: self.icon.url(:med),
      big: self.icon.url(:big)
    }
  end
  
end