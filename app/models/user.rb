# encoding: utf-8
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
    recommended_poi_ids = Array.new
    interests.each_with_index do |item, i|
      #no va bien
      recommended_poi_ids.push(call_function(item[0], interests.size - i))
    end
    puts " SIZEEE #{recommended_poi_ids.size}"
    return recommended_poi_ids
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
  
  def get_leisure(q)
    pois = Poi.where(supercategory_id: Supercategory.where(name: 'Ocio y Entretenimiento')).order('rating DESC').select(:id).sample(q).collect{|p| p.id }
    puts "SIZE leisure pois #{pois.size}"
  end
  
  def get_gastronomy(q)
    pois = Poi.where(supercategory_id: Supercategory.where(name: 'Gastronomia')).order('rating DESC').select(:id).sample(q).collect{|p| p.id }
  end
  
  def get_ferias(q)
    pois = Poi.where(supercategory_id: Supercategory.where(name: 'Ocio y Entretenimiento')).order('rating DESC').select(:id).sample(q).collect{|p| p.id }
  end
  
  def get_folclore(q)
    pois = Poi.where(supercategory_id: Supercategory.where(name: 'Ocio y Entretenimiento')).order('rating DESC').select(:id).sample(q).collect{|p| p.id }
  end
  
  def get_sport(q)
    pois = Poi.where(supercategory_id: Supercategory.where(name: 'Actividades Deportivas,')).order('rating DESC').select(:id).sample(q).collect{|p| p.id }
  end
  
  def get_culture(q)
    pois = Poi.where(supercategory_id: Supercategory.where(name: 'Cultura')).order('rating DESC').select(:id).sample(q).collect{|p| p.id }
  end
  
  def get_nature(q)
    pois = Poi.where(supercategory_id: Supercategory.where(name: 'Interes turístico & Recreation')).order('rating DESC').select(:id).sample(q).collect{|p| p.id }
  end
  
  def get_other(q)
    pois = Poi.where(supercategory_id: Supercategory.where(name: 'Interes turístico & Recreation')).order('rating DESC').select(:id).sample(q).collect{|p| p.id }
  end
  
  def get_buildings(q)
    pois = Poi.where(supercategory_id: Supercategory.where(name: 'Cultura')).order('rating DESC').select(:id).sample(q).collect{|p| p.id }
  end
  
  def get_friends(q)
    #recomendar lo que hacen los amigos
  end
  
  def get_events(q)
    pois = Poi.where(supercategory_id: Supercategory.where(name: 'Eventos')).order('rating DESC').select(:id).sample(q).collect{|p| p.id }
  end
  
  private
  
  def interests_hash
    
    interests = { :leisure => self.profiles.first.leisure,
           :gastronomy => self.profiles.first.gastronomy,
           :ferias => self.profiles.first.ferias,
           :folclore => self.profiles.first.folclore,
           :sport => self.profiles.first.sport,
           :nature=> self.profiles.first.nature,
           :culture=> self.profiles.first.culture, 
           :other=> self.profiles.first.other, 
           :buildings=> self.profiles.first.buildings, 
           :friends=> self.profiles.first.friends, 
           :events=> self.profiles.first.events
         }

  end
  
  def call_function(interest, q)
    case interest #compare with the key of the hash
      when :leisure
        puts "Call leisure"
        return get_leisure(q)
      when :gastronomy
        return get_gastronomy(q)
      when :ferias
        return get_ferias(q)
      when :folclore
        return get_folclore(q)
      when :sport
        return get_sport(q)
      when :culture
        return get_culture(q)
      when :nature
        return get_nature(q)
      when :other
        return get_other(q)
      when :buildings
        return get_buildings(q)
      when :friends
        return get_friends(q)
      when :events
        return get_events(q)
    end
  end
     
end
