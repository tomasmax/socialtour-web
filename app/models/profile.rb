class Profile < ActiveRecord::Base
  has_attached_file :image, styles: { gallery: "1060x400#", icon: "140x140#"  }, 
    url: "/profile/:hash.:extension",
    hash_secret: "/&){R8'PH:#5<=X?'Xx$@"
    
  belongs_to :user
  attr_accessible :about_me, :first_name, :gender, :i_dont_like, 
                  :i_like, :last_name, :is_married, :restrictions, :has_sons, 
                  :username,:image_content_type, :image_file_name, :image_file_size,
                  :image_updated_at, :image
                 
  
  def as_json options=nil
      options ||= {}
      options[:methods] = ((options[:methods] || []) + [:image_urls])
      super options
  end
  
  def image_urls
    {  
      gallery: self.image.url(:gallery),
      icon: self.image.url(:icon)
    }
  end
                  
end
