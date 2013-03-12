class Subcategory < ActiveRecord::Base
  belongs_to :category
  attr_accessible :description, :group, :is_route, :name, :slug, :foursquare_id, :foursquare_icon,
                  :name_eu, :name_en, :icon_file_name, :icon_content_type, :icon_file_size, :icon_update_at,
                  :category_id, :icon
end
