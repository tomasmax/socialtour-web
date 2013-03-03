class CategoryFoursquare < ActiveRecord::Base
  belongs_to :supercategory_foursquare
  
  has_many :subcategory_foursquares
  
  attr_accessible :foursquare_icon, :foursquare_id, :name, :name_en, :pluralName, :shortName
end
