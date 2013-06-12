class Package < ActiveRecord::Base
  extend FriendlyId
  
  belongs_to :category
  belongs_to :supercategory
  belongs_to :type_leisure
  belongs_to :type_time
  belongs_to :type_vehicle
  belongs_to :user
  belongs_to :provider
  
  has_many :package_pois
  has_many :pois, :through => :package_pois, :class_name => 'Poi'
  
  has_many :ratings, dependent: :delete_all
  has_many :comments, dependent: :delete_all
  has_many :events
  
  attr_accessible :description, :image_content_type, :image_file_name, :image_file_size, :image_update_at, :name, :price, :package_pois_attributes, :pois_attributes
  
  accepts_nested_attributes_for :pois
  accepts_nested_attributes_for :package_pois
  
  friendly_id :name, use: :slugged
  
  validates :name, presence: true, uniqueness: true
  
end
