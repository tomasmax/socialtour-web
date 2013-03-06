class RatingsController < InheritedResources::Base
  
   # POST /ratings.json
  def create
    rating_hash = params[:rating]
    rating_hash['user_id'] = current_user.id if current_user
    rating_hash['ip'] = request.remote_ip
    

    existing_rating = Rating.where('poi_id = ? AND (user_id = ? OR ip = ?)', rating_hash['poi_id'], rating_hash['user_id'], rating_hash['ip']).first
    
    if existing_rating
      old_rating = existing_rating.rating
      existing_rating.update_attributes rating_hash
      @rating = existing_rating
      @action = :updated
      
      #update poi's rating
      poi = @rating.poi
      poi.update_attributes rating: poi.rating - old_rating + @rating.rating
    else
      @rating = Rating.new(params[:rating])
      @rating.save
      @action = :created
      
      #update poi's rating
      poi = @rating.poi
      poi.update_attributes rating: poi.rating + @rating.rating, ratings_count: poi.ratings_count + 1
    end
    
    respond_to do |format|
      format.json { render json: {rating: @rating, poi_rating: poi.rating, poi_ratings_count: poi.ratings_count, action: @action}, status: :created, location: @rating }
    end
  end
  
end
