class Supercategory < ActiveRecord::Base
  extend FriendlyId
  
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
  
  friendly_id :name, use: :slugged
  #before_validation :generate_slug
  
  def self.populate(f2=nil,mi=nil,name)
    sc.id = Supercategory.last.id+1
    sc.name = name
    sc.name_en = f2.name_en if f2
    sc.foursquare_id = f2.foursquare_id if f2
    sc.minube_id = mi.id if mi
    sc.foursquare_icon = f2.foursquare_icon if f2
    sc.icon = open(sc.foursquare_icon) if sc.foursquare_icon 
  end
  
  def generate_slug
    if !self.slug
      self.slug = self.name.to_slug
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