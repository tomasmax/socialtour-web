class Photo < ActiveRecord::Base
  has_attached_file :image, styles: { full: "1280x800>", gallery: "1060x400#", slider_small: "150x59#", thumb_wide:"167x84#", thumb: "100x100#", icon_2x: "140x140#", icon: "70x70#",  }, 
    url: "/photo/:hash.jpg",
    hash_secret: "(%^{R8'PH:#5<=K*'Xx$@"
    
  belongs_to :poi
  belongs_to :user
  attr_accessible :image_content_type, :image_file_name, :image_file_size, :image_updated_at, :is_visible_on_index, :minube_url, :sequence, :subtitle, :subtitle_eu, :title, :title_eu, :image
  
  validates_uniqueness_of :minube_url
  
  def as_json options=nil
      options ||= {}
      options[:methods] = ((options[:methods] || []) + [:image_urls])
      super options
    end
  
  def image_urls
    { 
      full: self.image.url(:full),
      thumb: self.image.url(:thumb),
      icon_2x: self.image.url(:icon_2x),
      icon: self.image.url(:icon)
    }
  end
end
