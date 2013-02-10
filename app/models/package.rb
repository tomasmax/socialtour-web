class Package < ActiveRecord::Base
  belongs_to :category
  belongs_to :supercategory
  belongs_to :type
  belongs_to :user
  belongs_to :provider
  
  has_many :ratings
  has_many :events
  
  attr_accessible :description, :image_content_type, :image_file_name, :image_file_size, :image_update_at, :name, :price
end
