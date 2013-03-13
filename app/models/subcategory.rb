class Subcategory < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_attached_file :icon, styles: { small: '32x32>', med: '64x64>', big: '128x128>' }, 
    url: "/subcategory_img/:hash.:extension",
    hash_secret: "^{R8'PHca&Hrx@(%rvbo38q"
  
  has_many :pois
  belongs_to :category
  attr_accessible :description, :group, :is_route, :name, :slug, :foursquare_id, :foursquare_icon,
                  :name_eu, :name_en, :icon_file_name, :icon_content_type, :icon_file_size, :icon_update_at,
                  :category_id, :icon, :group
                  
  def icon_urls
    { 
      small: self.icon.url(:small),
      med: self.icon.url(:med),
      big: self.icon.url(:big)
    }
  end
  
end
