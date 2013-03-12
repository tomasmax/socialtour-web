class Category < ActiveRecord::Base
  extend FriendlyId 

  has_attached_file :icon, styles: { small: '32x32>', med: '64x64>', big: '128x128>' }, 
    url: "/category_img/:hash.:extension",
    hash_secret: "^{R0'KQwe$Sfgrx@(%rvbo38q"
    
  belongs_to :supercategory
  has_many :subcategories
  has_many :pois
  attr_accessible :description, :group, :is_route, :name, :slug, :foursquare_id, :foursquare_icon,
                  :name_eu, :name_en, :icon_file_name, :icon_content_type, :icon_file_size, :icon_update_at,
                  :supercategory_id, :icon

  
  validates :name, :presence => true
  validates :slug, :presence => true
  validates_uniqueness_of :name
  
  friendly_id :name, use: :slugged
  
  #before_validation :generate_slug
  
  def generate_slug
    if !self.slug
      self.slug = self.name.without_accents.to_slug
      self.save
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
