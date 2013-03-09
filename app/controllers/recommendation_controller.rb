class RecommendationController < ApplicationController
  
  def index
    if Package.all > 0
      @packages = current_user.recommend_packages
    end
    @pois = current_user.recommend_pois
    @events = current_user.recommend_events
  end
  
end
