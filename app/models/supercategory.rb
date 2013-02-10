class Supercategory < ActiveRecord::Base
  has_many :categories
  
  attr_accessible :icon_content_type, :icon_file_name, :icon_file_size, :icon_update_at, :name, :slug
end
