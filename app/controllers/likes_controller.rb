class LikesController < InheritedResources::Base
  before_filter :authenticate_user!
  
  def index
    get_likes
    @likes = Like.find_all_by_user_id(current_user.id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @likes}
    end
  end
  
  def get_likes
    
    auth = current_user.authentications.find_by_provider("facebook")
    # first, initialize a Graph API with your token
    graph = Koala::Facebook::GraphAPI.new(auth.auth_token) # pre 1.2beta
    graph = Koala::Facebook::API.new(auth.auth_token) # 1.2beta and beyond
    likes = graph.get_connections('me', 'likes')
    likes.each do |l|
      exists = Like.find_by_facebook_id(l['id'])
      if !exists
        like = Like.new l
        like.facebook_id = l['id']
        like.user_id = current_user.id
        like.save
      end 
    end
  end
  
end
