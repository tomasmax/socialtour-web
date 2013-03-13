class SupercategoryRelation < ActiveRecord::Base
  belongs_to :supercategory
  belongs_to :supercategory_foursquare
  belongs_to :supercategory_minube
  attr_accessible :supercategory_foursquare_id, :supercategory_minube_id, :supercategory_id
end
