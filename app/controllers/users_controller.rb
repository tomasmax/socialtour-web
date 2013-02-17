class UsersController < InheritedResources::Base
  
  #get facebook friends
  def facebook
    @friends = current_user.get_social_contacts(:facebook)
    
    friends_uids = @friends.collect {|f| f.identifier }
    #invited_users_uids = InvitedUser.where({uid: friends_uids}).select(:uid).collect {|u| u.uid}
    registered_users_uids = Authentication.where({uid: friends_uids}).select(:uid).collect{|a| a.uid}
    
    selected_uids = friends_uids - invited_users_uids - registered_users_uids
    
    @registered = @friends.select {|f| registered_users_uids.include?(f.identifier) }
    @no_registered = @friends.select {|f| selected_uids.include?(f.identifier) }

  end

=begin
  def publish_facebook
    check_authentication(:facebook)
    auth = current_user.authentications.find_by_provider('facebook')
    message_body = params[:message_body]
    me = FbGraph::User.me(auth.auth_token)
    @graph = Koala::Facebook::GraphAPI.new auth.auth_token

    if params[:friend]
      params[:friend].each do |f|
        friend = @graph.get_object(f[0])     
        if !params[:message][f[0]].empty?   
          composed_message = params[:message][f[0]]
        else
          composed_message = t('general.invitation.salutation').gsub('{name}', friend["name"]) + message_body
        end
=begin        
        # Post on f[0] users wall
        @graph.put_wall_post(composed_message,
        {
          :name => "the Human' Network",
          :message => "La red de los seres humanos",
          :link => "http://www.thehumansnetwork.com"
        }, f[0])
 =end        
        current_user.invited_users.create({ provider: 'facebook', uid: f[0] })
      end
      flash[:notice] = t('invites.done.notification')
    end
    redirect_to user_public_profile_path(current_user)
  end
=end
end
