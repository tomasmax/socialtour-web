class ExplorerController < ApplicationController
  
  #GET /explorer/places
  def places
    @counter = 0
    
    params[:order] = params[:order] ? params[:order].to_i : 0
    
    if params[:city]
      @city = City.find_by_id(params[:city]) #falta pasar parametro ciudad
      @pois = Poi.where(city_id: @city)
    else 
      @pois = Poi
    end
    
    #@pois = Poi
    
    @what_to_do = @pois.where(category_id: Category.where(group: 'do'))
    
    @what_to_see = @pois.where(category_id: Category.where(group: 'tosee'))
    
    @where_to_eat = @pois.where(category_id: Category.where(group: 'eat'))
    
    
    if params[:name] && !params[:name].empty?
      search = "%" + params[:name].downcase.sub(" ", "%") + "%"
      #@pois = @pois.where('name like ? OR name_eu like ?', search, search)
      @what_to_do = @what_to_do.where('lower(name) like ? OR lower(name_eu) like ?', search, search)
      @what_to_see = @what_to_see.where('lower(name) like ? OR lower(name_eu) like ?', search, search)
      @where_to_eat = @where_to_eat.where('lower(name) like ? OR lower(name_eu) like ?', search, search)
    end
    
    if params[:category] && params[:category] != "null"  && !params[:category].empty?
      #@pois = Poi.where(category_id: params[:category])
      @what_to_do = @what_to_do.where(category_id: params[:category])
      @what_to_see = @what_to_see.where(category_id: params[:category])
      @where_to_eat = @where_to_eat.where(category_id: params[:category])
    end

    if params[:order] == 0
      #@pois = @pois.order('created_at desc')
      @what_to_do = @what_to_do.order('created_at desc')
      @what_to_see = @what_to_see.order('created_at desc')
      @where_to_eat = @where_to_eat.order('created_at desc')
    else
      #@pois = @pois.order('rating desc')
      @what_to_do = @what_to_do.order('created_at desc')
      @what_to_see = @what_to_see.order('created_at desc')
      @where_to_eat = @where_to_eat.order('created_at desc')
    end
    
    @pois = @what_to_do + @what_to_see + @where_to_eat
    
    respond_to do |format|
      format.html # explorer.html.erb
   
    end  
  end
  
  def events
    @events = Event.all
  end
  
end
