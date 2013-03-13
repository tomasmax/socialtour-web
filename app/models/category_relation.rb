class CategoryRelation < ActiveRecord::Base
  belongs_to :category
  belongs_to :category_foursquare
  belongs_to :category_minube
  attr_accessible :category_foursquare_id, :category_minube_id, :category_id
end
