#require "sentimentalizer"

class User < ActiveRecord::Base
  has_many :authentications, dependent: :delete_all
  has_many :packages
  has_many :profiles, dependent: :delete_all
  accepts_nested_attributes_for :profiles, :reject_if => :all_blank, :update_only => true, :allow_destroy => true
  
  # Friendships
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  
  has_many :lists
  
  has_many :likes, dependent: :delete_all
  
  has_many :ratings
  has_many :comments, dependent: :delete_all
  
  belongs_to :city
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :city_id, :profiles_attributes
  
  def recommend_pois
    interests = interests_hash.sort {|a1,a2| a2[1].to_i <=> a1[1].to_i }  #order desc value
    interests.each do |i|
      call_function(i)
    end
  end
  
  def recommend_packages
    
  end
  
  def recommend_events
    
  end
  
  def analyze_sentiment(tweet)
    #return Sentimentalizer.analyze(tweet)
    #=> {'text' => 'i am so happy', 'probability' => '0.937', 'sentiment' => ':)' }
  end
  
  
  def get_social_contacts(provider)
    if auth = authentications.find_by_provider(provider)
      case provider
        when :foursquare
          client = Foursquare2::Client.new(:oauth_token => auth.auth_token, :api_version => '20130215', :locale=>'es') 
          return client.user_friends("self")
        when :facebook
          client = FbGraph::User.new('me', access_token: auth.auth_token)
          return client.friends
        when :twitter
          client = Twitter::Client.new(oauth_token: auth.auth_token, oauth_token_secret: auth.auth_secret)          
          return client.follower_ids
        #when :linkedin
          #client = LinkedIn::Client.new(LI_API_KEY, LI_SECRET)
          #client.authorize_from_access(auth.auth_token, auth.auth_secret)
          #return client.connections.all
      end
    end
  end
  
  private
  
  def interests_hash
    interests = { :leisure => self.profiles.leisure,
           :gastronomy => self.profiles.gastronomy,
           :ferias => self.profiles.ferias,
           :folclore => self.profiles.folclore,
           :sport => self.profiles.sport,
           :nature=> self.profiles.nature,
           :culture=> self.profiles.culture, 
           :other=> self.profiles.other, 
           :buildings=> self.profiles.buildings, 
           :friends=> self.profiles.friends, 
           :events=> self.profiles.events
         }
  end
  
  def call_function(interest)
    case interest[0]
      when :leisure
        return get_leisure
      when :ferias
        return get_ferias
      when :folclore
        return get_folclore
      when :sport
        return get_sport
      when :nature
        return get_nature
      when :other
        return get_other
      when :buildings
        return get_buildings
      when :friends
        return get_friends
      when :events
        return get_events
    end
  end
     
end
