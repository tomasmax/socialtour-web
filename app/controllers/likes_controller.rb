class LikesController < InheritedResources::Base
  before_filter :authenticate_user!
  
  def index
    get_likes(current_user)
    @likes = Like.find_all_by_user_id(current_user.id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @likes}
    end
  end
  
  
end
