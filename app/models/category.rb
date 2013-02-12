class Category < ActiveRecord::Base
  belongs_to :supercategory
  has_many :pois
  attr_accessible :description, :group, :is_route, :name, :slug
  
  validates :name, :presence => true
  validates :slug, :presence => true
  validates_uniqueness_of :slug
  
  before_validation :generate_slug
  
  def generate_slug
    if !self.slug
      self.slug = self.name.without_accents.to_slug
    end
  end
end
