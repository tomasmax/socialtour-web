class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uemail, :uid, :uname
end
