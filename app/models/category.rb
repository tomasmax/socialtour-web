class Category < ActiveRecord::Base
  has_attached_file :icon, styles: { small: '32x32>', med: '64x64>', big: '128x128>' }, 
    url: "/supercategory_img/:hash.:extension",
    hash_secret: "^{R0'KQwe$Sfgrx@(%rvbo38q"
    
  belongs_to :supercategory
  has_many :pois
  attr_accessible :description, :group, :is_route, :name, :slug, :foursquare_id, :foursquare_icon,
                  :name_eu, :name_en, :icon_file_name, :icon_content_type, :icon_file_size, :icon_update_at,
                  :supercategory_id, :icon

  
  validates :name, :presence => true
  validates :slug, :presence => true
  validates_uniqueness_of :slug
  
  before_validation :generate_slug
  
  def generate_slug
    if !self.slug
      self.slug = self.name.without_accents.to_slug
    end
  end
end
