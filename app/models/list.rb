class List < ActiveRecord::Base
  belongs_to :user
  has_many :pois, through: :list_contents
  has_many :packages, through: :list_content
  has_many :events, through: :list_content
  has_many :list_contents
  
  attr_accessible :description, :name, :poi_id, :package_id, :event_id
end
