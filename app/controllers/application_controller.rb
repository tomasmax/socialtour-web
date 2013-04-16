#!/bin/env ruby
# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_locale
  before_filter :api_call
  
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
        like = user.likes.new
        like.category = l['category'] #faltan coger las category_list nueva incorporacion de facebook
        like.facebook_id = l['id']
        if l['category_list']
          l['category_list'].each do |fc|
            cat = CategoryFacebook.find_by_id(fc['id'])
            if cat
              r = like.like_categories.new
              r.category_facebook_id = fc['id'] 
              r.save
            else
              catNew = like.category_facebooks.new fc
              catNew.save
            end
          end
        end
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
  
  def load_events_from_kulturklik(start,finish)
    #“yyyy-mm-dd”
    url = "http://www.kulturklik.euskadi.net/?api_call=events&from=" + start + "&to=" + finish + "&lang=es"
    url_eu = "http://www.kulturklik.euskadi.net/?api_call=events&from=" + start + "&to=" + finish + "&lang=eu"
    resp = Net::HTTP.get_response URI.parse(url)
    result = JSON.parse resp.body
    events = result['eventos']
    puts "Loading events from #{url}"
    
    if events
      events.each do |e|
        ev = Event.find_by_name(e['evento_titulo'])
        if ev.nil?
          puts "-Creating event #{e['evento_titulo']}"
          event = Event.new
          puts "Category #{e['evento_tipo']}"
          event.category_id = Category.find_by_name(e['evento_tipo']).id
          event.name = e['evento_titulo']
          event.name.gsub("&quot;", "")
          #event.name_eu
          event.longitude = e['longitude']
          event.latitude = e['latitude']
          event.starts_at = start
          event.ends_at = finish
          event.url = e['evento_url']
          doc = Nokogiri::HTML(open(event.url))
          #parsing html
          doc.css('div.eventoCampo').each do |el|
            if !el.children[0].content.nil?
              puts "-- Parsing HTML #{el.children[0].content}"
              case el.children[0].content.to_s       
                when "Protagonistas: "
                  el.children[1].content
                when "Fecha: "
                  event.starts_at = el.children[1].content
                  event.ends_at = el.children[1].content
                when "Fecha de Inicio: "
                  event.starts_at = el.children[1].content
                when "Fecha de Finalización: "
                  event.ends_at = el.children[1].content
                when "Hora/Horario: "
                  event.timetable = el.children[1].content
                when "Lugar: " #Centro Cívico Iparralde. Plaza Zuberoa, 1, Vitoria-Gasteiz (Álava)
                  event.place = el.children[1].content
                #when "Idioma: "
                  
                when "Precio: "
                  event.price = el.children[1].content
                when "Taquilla virtual: "
                  event.buy_ticket_url = el.children[1].content
              end
            end
          end
          
            #falta sacar la descripcion y eso
          event.description = "" 
          doc.css('div.observacionesEvento').children.each do |ch|
            event.description = event.description + ch.content
          end
          
          event.save
         end
      end
    end
  end
  
  def load_poi_from_forsquare(venue)
    #@clientFoursquare = Foursquare2::Client.new(client_id: "IN2OMEKAQP0JAZUB4G2YE5GS11AA3F2TRCCWQ5PVXCEG55PG", client_secret: "CHUBYYCIGCD5H54IB43UQOE4C3PU4FKAPI4CGW0VNQD21SYE", :api_version => '20130215', :locale=>'es')
    puts "Creating poi: "+venue.name
    poi = {name: venue.name,
      user_id: 2,#foursquare user
      latitude: venue.location.lat,
      longitude: venue.location.lng,
      address: venue.location.address,#siempre no tiene
      #telephone: , no hay telefono en foursquare
      #website: ,
      foursquare_id: venue.id,
      minube_id: nil,
      foursquare_url: venue.canonicalUrl,
      checkins_count: venue.stats.checkinsCount,
      users_count: venue.stats.usersCount,
      tip_count: venue.stats.tipCount,
      likes_count: venue.likes.count
      }
 
    poi 
  end
  
  def load_venue_photos_from_foursquare(poi)
    #@clientFoursquare = Foursquare2::Client.new(client_id: "IN2OMEKAQP0JAZUB4G2YE5GS11AA3F2TRCCWQ5PVXCEG55PG", client_secret: "CHUBYYCIGCD5H54IB43UQOE4C3PU4FKAPI4CGW0VNQD21SYE", :api_version => '20130215', :locale=>'es')
    photos = @@clientFoursquare.venue_photos(poi.foursquare_id, group: "venue")
    
    photos.items.each_with_index do |photo, i|
      begin
        if i > 6
          break
        end
        foursquare_photo_url = photo.prefix+photo.width.to_s+"x"+photo.height.to_s+photo.suffix

        unless Photo.find_by_foursquare_url(foursquare_photo_url)
          p = poi.photos.new(user_id: 2, 
            image: open(foursquare_photo_url), 
            foursquare_url: foursquare_photo_url,
            image_file_name: "#{poi.name}_#{i}.jpg") #"#{poi.name}_#{i}.jpg"
          if p.save!
            puts "New photo #{foursquare_photo_url}"
          end
        end
        
      rescue Exception => e
        puts "EXC[ Error loading photo #{photo['url']}: #{e} ]"
      end
    end
    
  end
    
  def load_poi_tips(poi)
    # Load description from first tip
    tips = @@clientFoursquare.venue_tips(poi.foursquare_id, sort: "recent")    

    #Load all tips to poi comments
    if tips.items
     
      tips.items.each do |t|
        c = Comment.find_by_foursquare_id(t.id)
        if c.nil?
          comment = poi.comments.new
          comment.user_id = 2 #foursquare user
          comment.comment = t.text
          if comment.save!
            puts "-- Created comment for poi"+poi.name
          end
        end
      end 
      #c = Comment.find_by_poi_id(poi.id).comment
      #poi.update_attribute(description: c)
    end
  end

  def import_pois_from_foursquare
    @@clientFoursquare = Foursquare2::Client.new(client_id: "IN2OMEKAQP0JAZUB4G2YE5GS11AA3F2TRCCWQ5PVXCEG55PG", client_secret: "CHUBYYCIGCD5H54IB43UQOE4C3PU4FKAPI4CGW0VNQD21SYE", :api_version => '20130215', :locale=>'es')
    City.all.each do |city|
      puts "Loading #{city.name} pois"
      Category.all.each do |category|
        if category.foursquare_id
          puts "-Loading #{category.name} category pois"
          pois = @@clientFoursquare.search_venues(near: city.name, intent: 'browse', radius: 1500, limit: 5, categoryId: category.foursquare_id) #near or ll, query, radius, categoryId
          #meter parametro igual de localizacion o categoria
          load_venues_from_foursquare(pois,category)
        end
      end
    end
  end
  
  # Search for trending venues
    #
    # @param [String] :ll Latitude and longitude in format LAT,LON
    # @param [Hash]  options
    # @option options Integer :limit - Number of results to return, up to 50.
    # @option options Integer :radius - Radius in meters, up to approximately 2000 meters.
  def import_trending_topic_pois_from_foursquare(city)
    #clientFoursquare.trending_venues('40.7,-74')
    lng = city.longitude.longitude.to_s('F')
    ll = city.latitude.to_s('F')+","+lng
    #returns most cheched places
    @@clientFoursquare.trending_venues(ll, radius: 1500)
    
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
  def import_recommended_pois_from_foursquare(city,novelty) #novelty new = new pois, old = checked pois
    #foursquareclient with user token
    auth = Authentications.find_by_user_id_and_provider(current_user.id, 'foursquare')
    if auth
      client = Foursquare2::Client.new(:oauth_token => auth, locale: 'es')
      lng = city.longitude.longitude.to_s('F')
      ll = city.latitude.to_s('F')+","+lng
      pois = client.explore_venues(ll: ll, radius: 1500, limit: 30, novelty: novelty)
      recommended_poi_ids = Array.new
      pois.groups do |group|
        puts "Loading #{group.name} group recommeded pois"
        group.items.each do |item|
          #ver si exsite en la BD, sino existe crearlo y meterlo en array par devolver
          category = Category.find_by_id(item.venue.categories[0].id)
          if category
            if create_poi(item.venue, category)
              puts "Recommended poi #{item.venue.name}"
              poi = Poi.find_by_foursquare_id(item.venue.id)
              recommended_poi_ids.push(poi)
            end
          end
        end   
      end
    end
    return recommended_poi_ids
  end
  
   def load_venues_from_foursquare(pois, category)

    total_saved = 0
    if pois.venues
      puts "#{pois.size} pois readed"

      pois.venues.each do |venue|
        if create_poi(venue)
          total_saved = total_saved + 1
        end
      end
    end

  end
  
   def create_poi(venue, category)
    begin
      poi = Poi.find_by_name(venue.name)
      if poi
        poi.update_attributes load_poi_from_forsquare(venue)

      else
        poi = category.pois.new load_poi_from_forsquare(venue)

        if poi.save!
          puts "--New poi #{poi.name}"
        end
      end

      if poi
        load_venue_photos_from_foursquare(poi)
        load_poi_tips(poi)
        return true
      end

    rescue Exception => e
      puts "Error #{e}"
    end
  end
   
  def load_poi_from_minube(poi_hash)
    cat = Category.find_by_minube_id(poi_hash["category"]["id"])
    poi = {name: poi_hash["name"],
      user_id: 1, #minube user
      latitude: poi_hash["latitude"],
      longitude: poi_hash["longitude"],
      address: poi_hash["address"],
      telephone: poi_hash["telephone"],
      website: poi_hash["website"],
      minube_id: poi_hash["id"],
      minube_url: poi_hash["url"],
      category_id: cat.id,
      supercategory_id: cat.supercategory_id}
    
    
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
            image_file_name: "#{poi.name}_#{i}.jpg").save
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
      
      Supercategory.all.each do |sc|
        if sc.minube_id
          
          pois_url = "#{base_url}&city=#{city.minube_id}&supercategory=#{sc.minube_id}"
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
