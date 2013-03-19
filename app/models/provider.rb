class Provider < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_attached_file :image, styles: { gallery: "1060x400#", icon: "140x140#" }, 
    url: "/provider/:hash.:extension",
    hash_secret: "(%^{R8'PH:#5<=K*'RF$%"
    
  belongs_to :city
  belongs_to :category
  belongs_to :supercategory
  has_many :packages
  has_many :events
  attr_accessible :description, :name,:image_content_type, :image_file_name, :image_file_size,
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
