class RecommendationController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    if current_user.packages
      @packages = current_user.recommend_packages
    end
    
    #@pois = current_user.recommend_pois
    #@events = current_user.recommend_events
    
    ids = current_user.recommend_pois
    
    ids.each do |id|
      puts "ID #{id}"
    end
    
    #ids = Poi.where(category_id: Category.where(group: 'tosee')).select(:id).sample(12).collect{|p| p.id }
    @recommended_pois = Poi.where(id: ids)
       
  end
  
end
