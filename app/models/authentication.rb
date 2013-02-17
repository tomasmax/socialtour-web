class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uemail, :uid, :uname, :auth_secret, :auth_token
end
