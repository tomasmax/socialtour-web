# encoding: utf-8
class PackagesController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:create, :new]
  before_filter :check_ownership, only: [:edit, :update]
  
  def check_ownership
    @package = current_user.packages.find(params[:id])
    raise ActionController::RoutingError.new('Not Found') unless @package
  end
  
  # GET /projects/new
  # GET /projects/new.xml
  def new
    @package = current_user.packages.new
    #@package.package_pois.build

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @package }
    end
  end
  
  # POST /pois
  # POST /pois.json
  def create
    @package = current_user.packages.new(params[:package].merge(is_verified: false))
    
    respond_to do |format|
      if @package.save
        format.html { redirect_to package_url(@package), notice: 'Package was successfully created.' }
        format.json { render json: @package, status: :created, location: @package }
      else
        format.html { render action: "new" }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /packages
  def index
    @packages = Package.all
    
    recommended_pois = current_user.recommend_pois
    if params[:type_leisure] #solo, pareja, amigos, otros
      case params[:type_leisure]
      when "Solo"
        
      when "Pareja"
        
      when "Amigos"
        
      end
        
    end
    
    
    if params[:type_time] #Mañana, tarde, noche, todo el día, fin de semana
      case params[:type_time]
      when "Mañana"
        ids = Poi.where(category_id: Category.where(group: 'tosee')).select(:id).sample(3).collect{|p| p.id }
        @places_morning = Poi.where(id: ids)
        id = Poi.where(category_id: Category.where(group: 'eat')).select(:id).sample(1).collect{|p| p.id }
        @eat = Poi.where(id: id)
        
      when "Tarde"
        ids = Poi.where(category_id: Category.where(group: 'do')).select(:id).sample(3).collect{|p| p.id }
        @places_afternoon = Poi.where(id: ids)
        
      when "Noche"
        ids = Poi.where(category_id: Category.where(group: 'do')).select(:id).sample(3).collect{|p| p.id }
        @places_night = Poi.where(id: ids)
        
      when "Todo el día"
        ids = Poi.where(category_id: Category.where(group: 'tosee')).select(:id).sample(3).collect{|p| p.id }
        @places_morning = Poi.where(id: ids)
        id = Poi.where(category_id: Category.where(group: 'eat')).select(:id).sample(1).collect{|p| p.id }
        @eat = Poi.where(id: id)
        ids = Poi.where(category_id: Category.where(group: 'do')).select(:id).sample(3).collect{|p| p.id }
        @places_afternoon = Poi.where(id: ids)
        
      when "Fin de semana"
        
      end
      
    end
    
    if params[:type_vehicle] #Bicicleta, andando, correr, coche, moto
      case params[:type_vehicle]
      when "Bicicleta"
        
      when "Andando"
        
      when "Correr"
        
      when "Coche"
        
      when "Moto"
        
      end
      
    end
    
    
    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end
  
  # GET /packages/:id
  def show
    @package = Package.find_by_id params[:id]
    @pois = @package.pois
    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end
  
  def create_package
    if params[:type_leisure] #solo, pareja, amigos, otros
      
    end
    if params[:type_time] #Maniana, tarde, noche, todo el día, fin de semana
      
    end
    if params[:type_vehicle] #Bicicleta, andando, correr, coche, moto
      
    end
  end
  
end
