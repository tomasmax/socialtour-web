class Comment < ActiveRecord::Base
  belongs_to :poi
  belongs_to :user
  belongs_to :package
  attr_accessible :comment, :poi_id, :user_id, :package_id
  
  paginates_per 10
  
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:user_name, :poi_slug, :poi_name, :package_name])
    super options
  end
  
  def user_name
    user.name if user
  end
  
  def poi_slug
    poi.slug if poi
  end
  
  def poi_title
    poi.name if poi
  end
  
  def package_name
    package.name if package
  end
end
