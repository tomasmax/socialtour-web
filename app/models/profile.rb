class Profile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :about_me, :first_name, :gender, :i_dont_like, :i_like, :last_name, :married, :restrictions, :soons, :username
end