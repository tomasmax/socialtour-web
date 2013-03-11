class SupercategoryMinube < ActiveRecord::Base
  has_many :category_minubes
  attr_accessible :name
end
