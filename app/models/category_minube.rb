class CategoryMinube < ActiveRecord::Base
  belongs_to :supercategory_minube
  attr_accessible :group, :name, :id, :supercategory_minube_id
end
