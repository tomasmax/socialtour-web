class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_locale
  before_filter :api_call
  
  helper_method :current_user  
  
  def poi_url(poi)
    "/#{t 'resources.pois'}/#{poi.slug}"
  end
  
  def load_poi_from_minube(poi_hash)

    poi = {title: poi_hash["name"],
      user_id: 1,
      latitude: poi_hash["latitude"],
      longitude: poi_hash["longitude"],
      address: poi_hash["address"],
      telephone: poi_hash["telephone"],
      website: poi_hash["website"],
      minube_id: poi_hash["id"],
      minube_url: poi_hash["url"],
      category_id: poi_hash["category"]["id"],
      supercategory_id: poi_hash["supercategory"]["id"]}
    
    
    # Load description from comments
    base_url = "http://api.minube.com/places/comments.json?api_key=c9fd01a957af1f2afb8b3a31f83257c3&order=total_score&poi=#{poi_hash["id"]}"
    
    resp = Net::HTTP.get_response URI.parse(base_url)
    result = JSON.parse resp.body
    comments = result["response"]["comments"]
    
    if comments.first
      poi[:description] = comments.first["content"]
    end
    
    poi 
  end
  
  def load_photos_from_poi(poi)
    base_url = "http://api.minube.com/media/pictures.json?api_key=c9fd01a957af1f2afb8b3a31f83257c3&poi=#{poi.minube_id}"
    
    resp = Net::HTTP.get_response URI.parse(base_url)
    result = JSON.parse resp.body
    photos = result["response"]["pictures"]
    
    photos.each do |photo|
      begin
        unless Photo.find_by_minube_url(photo['url'])
          poi.photos.new(user_id: 1, 
            image: open(photo['url']), 
            minube_url: photo['url'],
            image_file_name: "image.jpg").save
          puts "New photo #{photo['url']}"
        end
      rescue Exception => e
        puts "ESC[31m Error loading photo #{photo['url']}: #{e}"
      end
    end
    
  end
  
  def import_pois_from_minube
    base_url = "http://api.minube.com/places/pois.json?api_key=c9fd01a957af1f2afb8b3a31f83257c3"
    
    total_saved = 0
    
    City.all.each do |city|
      puts "Importing city #{city.name}"
    
      pois_url = "#{base_url}&city=#{city.minube_id}"
      resp = Net::HTTP.get_response URI.parse(pois_url)
      result = JSON.parse resp.body
      pois_list = result["response"]["pois"]
      
      if pois_list
        puts "#{pois_list.count} pois readed"
        
        pois_list.each do |poi_hash|
          begin
            poi = Poi.find_by_minube_id(poi_hash["id"])
            if poi
              poi.update_attributes load_poi_from_minube(poi_hash)
            else
              poi = city.poi.new load_poi_from_minube(poi_hash)
              poi.save
              
              puts "New poi #{poi.title}"
            end
            
            if poi
              load_photos_from_poi(poi)
              
              total_saved = total_saved + 1
            end
          rescue Exception => e
            puts "Error #{e}"
          end
        end
        
      end
    end
    total_saved
  end
  
  def api_call
    
    if request.host.split('.').first == 'api'
      puts request.host.split('.').first
      
      params[:format] = :json
      
      if !params[:api_key]
        head :forbidden
        false
      end
      
      api_key = ApiKey.find_by_key(params[:api_key])
      if !api_key
        head :forbidden
        false
      else
        api_key.calls_count = api_key.calls_count + 1
        api_key.save
      end
    end
    true
  end
  
  def set_locale
    if params[:locale]
      session[:locale] = params[:locale]
    end
    session[:locale] = I18n.default_locale unless session[:locale]
    
    I18n.locale = session[:locale]
  end
  
end
