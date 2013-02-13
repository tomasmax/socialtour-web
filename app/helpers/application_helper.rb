module ApplicationHelper
  
  def title
    base_title = SocialTour
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

=begin 
  def poi_url(poi)
    if poi.category && poi.category.is_route
      "/rutas/#{poi.slug}"
    else
      "/sitios/#{poi.slug}"
    end
  end
  
  def city_url(city)
    "/cities/#{city.slug}"
  end
  
  def user_url(user)
    if user.url
      return user.url
    else
      return "/usuarios/#{user.id}"
    end
  end
=end
  
  String.class_eval do
  
    def to_slug
      # strip the string
      ret = self.downcase.strip
  
      #blow away apostrophes
      ret.gsub! /['`]/, ""
  
      # @ --> at, and & --> and
      ret.gsub! /\s*@\s*/, " at "
      ret.gsub! /\s*&\s*/, " and "
  
      # replace all non alphanumeric, periods with dash
      ret.gsub! /\s*[^A-Za-z0-9\.]\s*/, '-'
  
      # replace underscore with dash
      ret.gsub! /[-_]{2,}/, '-'
  
      # convert double dashes to single
      ret.gsub! /-+/, "-"
  
      # strip off leading/trailing dash
      ret.gsub! /\A[-\.]+|[-\.]+\z/, ""
  
      ret
    end
    
  end
  
end
