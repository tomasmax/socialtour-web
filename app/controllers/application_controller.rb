class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_locale
  before_filter :api_call

  @clientFoursquare = Foursquare2::Client.new(client_id: "IN2OMEKAQP0JAZUB4G2YE5GS11AA3F2TRCCWQ5PVXCEG55PG", client_secret: "CHUBYYCIGCD5H54IB43UQOE4C3PU4FKAPI4CGW0VNQD21SYE", :api_version => '20130215', :locale=>'es')
   
  def poi_url(poi)
    "/#{t 'resources.pois'}/#{poi.slug}"
  end
  
  
  def get_likes(user)
    
    auth = user.authentications.find_by_provider("facebook")
    # first, initialize a Graph API with your token
    #graph = Koala::Facebook::GraphAPI.new(auth.auth_token) # pre 1.2beta
    graph = Koala::Facebook::API.new(auth.auth_token) # 1.2beta and beyond
    likes = graph.get_connections('me', 'likes')
    likes.each do |l|
      exists = Like.find_by_facebook_id(l['id'])
      if !exists
        like = Like.new l
        like.facebook_id = l['id']
        like.user_id = user.id
        like.save
      end 
    end
  end
  
  def add_account(user, auth)
    authentication = user.authentications.new(provider: auth[:provider], uid: auth[:uid])
    if auth[:extra]
      authentication.uname = auth['extra']['raw_info']['username']
      authentication.uemail = auth['extra']['raw_info']['email']
    end
    token = auth[:credentials][:token] rescue nil
    token ||= auth[:extra][:access_token].token rescue nil
    authentication.auth_token = token
    secret = auth[:credentials][:secret] rescue nil
    secret ||= auth[:extra][:access_token].secret rescue nil
    authentication.auth_secret = secret

    if authentication.save
      #complete user information
      #user.profile.image = open(auth[:info][:image]) unless user.profile.image.exists? || !auth[:info][:image]
      profile = user.profiles.new
      profile.first_name = auth[:info][:first_name] if user.profiles.first.first_name.blank?
      profile.last_name = auth[:info][:last_name] if user.profiles.first.last_name.blank?
      if auth[:extra]
        if auth[:extra][:location]
          city = City.find_by_name(auth[:extra][:location][:name])
        end
        user.city = city
        profile.gender = auth[:extra][:raw_info][:gender] if auth[:extra][:raw_info][:gender]
      end
      if auth[:info]
        if auth[:info][:image]
          profile.image = open(auth[:info][:image])
        end
      end
      profile.save!
    end
  end
  
  def load_events_from_kulturtik(start,finish)
    #“yyyy-mm-dd”
    url = "http://www.kulturklik.euskadi.net/?api_call=events&from=" + start + "&to=" + finish + "&lang=es"
    url_eu = "http://www.kulturklik.euskadi.net/?api_call=events&from=" + start + "&to=" + finish + "&lang=eu"
    resp = Net::HTTP.get_response URI.parse(url)
    result = JSON.parse resp.body
    events = result['evento']
    
    if events
      events.each do |e|
        event = Event.new
        event.category_id = Category.find_by_name(e['evento_tipo']).id
        event.name = e['evento_titulo']
        #event.name_eu
        event.longitude = e['longitude']
        event.latitude = e['latitude']
        event.starts_at = start
        event.ends_at = finish
        poi = Poi.find_by_longitude_and_latitude(event.longitude, event.latitude)
        if poi
          event.poi_id = poi.id
        end
        event.url = e['evento_url']
        event.save
      end
    end
  end
  
  def load_poi_from_forsquare(venue)
    cat = Category.find_by_foursquare_id(venue.categories[0].id)
    poi = {name: venue.name,
      user_id: 2,#foursquare user
      latitude: venue.location.lat,
      longitude: venue.location.lng,
      address: venue.location.address,#siempre no tiene
      #telephone: , no hay telefono en foursquare
      #website: ,
      foursquare_id: venue.id,
      foursquare_url: venue.canonicalUrl,
      checkins_count: venue.stats.checkinsCount,
      users_count: venue.stats.usersCount,
      tip_count: venue.stats.tipCount,
      likes_count: venue.likes.count,
      category_id: cat.id,
      supercategory_id: cat.supercategory.id}
      
    # Load description from first tip
    tips = @clientFoursquare.venue_tips("#{poi.foursquare_id}", sort: "recent")    
    
    #Load all tips to poi ratings
    if tips.items
      poi[:description] = tips.items[0].text
      
      tips.items.each do |t|
        comment = Comment.new
        comment.poi_id = poi.id
        comment.user_id = 2 #foursquare user
        comment.comment = t.text
        comment.save
      end
      
    end
 
    poi 
  end
  
  def load_venue_photos_from_foursquare(poi)
    
    photos = @clientFoursquare.venue_photos("#{poi.foursquare_id}", group: "venue")
    
    photos.items.each do |photo|
      begin
        foursquare_photo_url = photo.prefix+photo.suffix
        unless Photo.find_by_foursquare_url(foursquare_photo_url)
          poi.photos.new(user_id: 2, 
            image: open(foursquare_photo_url), 
            foursquare_url: foursquare_photo_url,
            image_file_name: "image.jpg").save
          puts "New photo #{photo['url']}"
        end
      rescue Exception => e
        puts "EXC[ Error loading photo #{photo['url']}: #{e} ]"
      end
    end
    
  end
  
  # Explore venues
    #
    # @param [Hash]  options
    # @option options String :ll - Latitude and longitude in format LAT,LON
    # @option options Integer :llAcc - Accuracy of the lat/lon in meters.
    # @option options Integer :alt - Altitude in meters
    # @option options Integer :altAcc - Accuracy of the altitude in meters
    # @option options Integer :radius - Radius to search within, in meters
    # @option options String :section - One of food, drinks, coffee, shops, or arts. Choosing one of these limits results to venues with categories matching these terms.
    # @option options String :query - Query to match venues on.
    # @option options Integer :limit - The limit of results to return.
    # @option options String :intent - Limit results to venues with specials.
    # @option options String :novelty - Pass new or old to limit results to places the acting user hasn't been or has been, respectively. Omitting this parameter returns a mixture.

  def load_pois_from_foursquare
    
    City.all.each do |city|
      pois = @clientFoursquare.search_venues(near: city.name) #near or ll, query, radius, categoryId
      #meter parametro igual de localizacion o categoria
      total_saved = 0
      if pois.venues
          puts "#{pois.count} pois readed"
      
          pois.venues.each do |venue|
            begin
              poi = Poi.find_by_foursquare_id_and_name(venue.id,venue.name)
              if poi
                poi.update_attributes load_poi_from_forsquare(venue)
              else
                poi = city.pois.new load_poi_from_forsquare(venue)
                poi.save
                
                puts "New poi #{poi.name}"
              end
              
              if poi
                load_venue_photos_from_foursquare(poi)
                
                total_saved = total_saved + 1
              end
             
            rescue Exception => e
              puts "Error #{e}"
            end
          end
      end
    end
  end
  
  def load_poi_from_minube(poi_hash)

    poi = {name: poi_hash["name"],
      user_id: 1,#minube user
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
        puts "EXC[ Error loading photo #{photo['url']}: #{e} ]"
      end
    end
    
  end
  
  def import_pois_from_minube
    base_url = "http://api.minube.com/places/pois.json?api_key=c9fd01a957af1f2afb8b3a31f83257c3"
    
    total_saved = 0
    
    City.all.each do |city|
      puts "Importing city #{city.name}"
    
      pois_url = "#{base_url}&city=#{city.minube_id}&supercategory=1"
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
              poi = city.pois.new load_poi_from_minube(poi_hash)
              poi.save
              
              puts "New poi #{poi.name}"
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
