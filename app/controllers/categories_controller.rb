class CategoriesController < InheritedResources::Base
  # GET /categories.json
  def index
    @categories = Categiry.all

    respond_to do |format|
      format.json { render json: @categories }
    end
  end

  # GET /categories/show
  def show
    if params[:category]
      @category = Category.find_by_slug(params[:category]) if params[:category]
      @pois = @category.pois if @category
    end
    
    unless @category
      if params[:group] == "que-hacer"
        @pois = Poi.where(category_id: Category.where(group: 'do'))
      elsif params[:group] == "que-ver"
        @pois = Poi.where(category_id: Category.where(group: 'tosee'))
      elsif params[:group] == "donde-comer"
        @pois = Poi.where(category_id: Category.where(group: 'eat'))
      elsif params[:group] == "donde-dormir"
        @pois = Poi.where(category_id: Category.where('`categories`.`group` LIKE "sleep%"').all)
      end
    end
    
    @city = City.find_by_slug(params[:city]) if params[:city]
    if @city
      @pois = @pois.where city_id: @city.id
    end
    
    @pois = @pois.page(params[:page])
  
    respond_to do |format|
      format.html # show_category.html.erb
      format.json { render json: @pois }
    end
  end
end
