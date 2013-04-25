class PackagesController < InheritedResources::Base
  
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
