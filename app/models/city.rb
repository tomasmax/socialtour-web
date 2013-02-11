class City < ActiveRecord::Base
  belongs_to :country
  has_many :users
  attr_accessible :icon_content_type, :icon_file_name, :icon_file_size, :icon_update_at, :name, :name_eu, :slug, :minube_id
end
