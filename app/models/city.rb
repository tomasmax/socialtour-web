class City < ActiveRecord::Base
  belongs_to :country
  has_many :users
  attr_accessible :name
end
