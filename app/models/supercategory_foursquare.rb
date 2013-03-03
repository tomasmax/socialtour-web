class SupercategoryFoursquare < ActiveRecord::Base
  has_many :category_foursquares
  
  attr_accessible :foursquare_icon, :foursquare_id, :name, :name_en, :pluralName, :shortName, :id
end
