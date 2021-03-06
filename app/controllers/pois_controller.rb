class PoisController < InheritedResources::Base
  
  before_filter :authenticate_user!, only: [:create, :new, :edit, :update]
  
  @@last_minube_update = Time.at(0)
  
  def crawler
    
  end
  
  def check_ownership
    @poi = current_user.pois.find(params[:id])
    raise ActionController::RoutingError.new('Not Found') unless @poi
  end
  
  # GET /pois
  # GET /pois.json
  def index
    ## Check if has pass more than limit time from last update
    if (Time.now - @@last_minube_update).to_i > 60*60*4 # 4 hours
      Thread.new do
        begin
          @@last_minube_update = Time.now
          #import_pois_from_minube
          import_pois_from_foursquare
          #load_events_from_kulturklik(Date.today.to_s, (Date.today+1.month).to_s) #“yyyy-mm-dd”
        rescue Exception => e
          puts "Error updating from minube or foursquare: #{e}"
        end
      end
    end
    
    # returns Geocoder::Result object
    @location = request.location
    
    respond_to do |format|
      format.html do # index.html.erb
        
        ids = Poi.where(category_id: Category.where(group: 'do')).select(:id).sample(3).collect{|p| p.id }
        @what_to_do = Poi.where(id: ids)
        
        ids = Poi.where(category_id: Category.where(group: 'tosee')).select(:id).sample(3).collect{|p| p.id }
        @what_to_see = Poi.where(id: ids)
        
        ids = Poi.where(category_id: Category.where(group: 'eat')).select(:id).sample(3).collect{|p| p.id }
        @where_to_eat = Poi.where(id: ids)
    
        ids = Poi.where(category_id: Category.where(is_route: true)).select(:id).sample(4).collect{|p| p.id }
        @top_routes = Poi.where(id: ids)
        
        @slider_photos = Photo.where(is_visible_on_index: true).order(:sequence).limit(7)
      end
      
      format.json do
        what_to_do = Poi.where(category_id: Category.where(group: 'do')).order('rating DESC').page(params[:page]).per(10)
        what_to_see = Poi.where(category_id: Category.where(group: 'tosee')).order('rating DESC').page(params[:page]).per(10)
        where_to_eat = Poi.where(category_id: Category.where(group: 'eat')).order('rating DESC').page(params[:page]).per(10)
        where_to_sleep = Poi.where(category_id: Category.where('`categories`.`group` LIKE "sleep"')).order('rating DESC').page(params[:page]).per(10)
        
        render json: { todo: what_to_do, tosee: what_to_see, toeat: where_to_eat, tosleep: where_to_sleep }
      end 
    end
  end
  
  # GET /pois/poi+slug
  # GET /pois/poi+slug.json
  respond_to :html, :json, :gpx, :kml
  def show
    @poi = Poi.find_by_slug(params[:slug])
    
    @title = "#{@poi.name} | SocialTour"
    
    poi = Poi.where(category_id: Category.where(group: 'do'), city_id: @poi.city).select(:id).sample
    @what_to_do = Poi.where(id: poi.id) if poi
    
    poi = Poi.where(category_id: Category.where(group: 'tosee'), city_id: @poi.city).select(:id).sample
    @what_to_see = Poi.where(id: poi.id) if poi
    
    poi = Poi.where(category_id: Category.where(group: 'eat'), city_id: @poi.city).select(:id).sample
    @where_to_eat = Poi.where(id: poi.id) if poi
    
    @comments = Comment.where(poi_id: @poi).order('created_at DESC')
    
    @comments = @comments.page(params[:page])
    #@event = Event.new
    #@event.poi = @poi
    
    respond_to do |format|
      format.kml # show.kml.erb
      format.gpx # show.gpx.erb
      format.html # show.html.erb
      format.json do 
        @poi.route_points_list = @poi.route_points
        render json: @poi
      end
    end
  end
  
  # POST /pois
  # POST /pois.json
  def create
    @poi = current_user.pois.new(params[:poi])
    
    respond_to do |format|
      if @poi.save
        format.html { redirect_to poi_url(@poi), notice: 'Poi was successfully created.' }
        format.json { render json: @poi, status: :created, location: @poi }
      else
        format.html { render action: "new" }
        format.json { render json: @poi.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
