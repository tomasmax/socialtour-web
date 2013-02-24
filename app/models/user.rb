#require "sentimentalizer"

class User < ActiveRecord::Base
  has_many :authentications, dependent: :delete_all
  has_many :packages
  has_many :profiles, dependent: :delete_all
  # Social contacts
  has_many :user_social_contacts
  has_many :social_contacts, through: :user_social_contacts
  
  has_many :likes, dependent: :delete_all
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
                  
  belongs_to :city
  attr_accessible :email, :name
  
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
  
  
  def analyze_sentiment(tweet)
    #return Sentimentalizer.analyze(tweet)
    #=> {'text' => 'i am so happy', 'probability' => '0.937', 'sentiment' => ':)' }
  end
  
end
