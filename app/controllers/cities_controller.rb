class CitiesController < InheritedResources::Base
  
  # GET /cities
  def index
    @cities = City.order 'name'
    respond_to do |format|
      format.html # index.html.erb
      format.json {render json: @cities}
    end
  end
  
  # GET /cities/:slug
  def show
    @city = City.find_by_slug params[:slug]
    
    @what_to_do = @city.pois.where(category_id: Category.where(group: 'do'), city_id: @city).order('rating desc').limit(4)
    @what_to_see = @city.pois.where(category_id: Category.where(group: 'tosee'), city_id: @city).order('rating desc').limit(4)
    @where_to_eat = @city.pois.where(category_id: Category.where(group: 'eat'), city_id: @city).order('rating desc').limit(4)
    @where_to_sleep = @city.pois.where(category_id: Category.where("`categories`.`group` LIKE 'sleep%'"), city_id: @city).order('rating desc').limit(4)

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
end
