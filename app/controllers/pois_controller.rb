class PoisController < InheritedResources::Base
  @@last_minube_update = Time.at(0)
  
  # GET /pois
  # GET /pois.json
  def index
    ## Check if has pass more than limit time from last update
    if (Time.now - @@last_minube_update).to_i > 60*60*4 # 4 hours
      Thread.new do
        begin
          @@last_minube_update = Time.now
          import_pois_from_minube
        rescue Exception => e
          puts "Error updating from minube: #{e}"
        end
      end
    end

    respond_to do |format|
      format.html do # index.html.erb
        
        ids = Poi.where(category_id: Category.where(group: 'do')).select(:id).sample(3).collect{|p| p.id }
        @what_to_do = Poi.where(id: ids)
        
        ids = Poi.where(category_id: Category.where(group: 'tosee')).select(:id).sample(3).collect{|p| p.id }
        @what_to_see = Poi.where(id: ids)
        
        ids = Poi.where(category_id: Category.where(group: 'eat')).select(:id).sample(1).collect{|p| p.id }
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
  
end