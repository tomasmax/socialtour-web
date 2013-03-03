class SubcategoryFoursquare < ActiveRecord::Base
  belongs_to :category_foursquare
  
  attr_accessible :foursquare_icon, :foursquare_id, :name, :name_en, :pluralName, :shortName
end
