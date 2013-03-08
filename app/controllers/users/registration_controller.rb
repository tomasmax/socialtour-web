class Users::RegistrationsController < Devise::RegistrationsController
  
  def new
    super
  end

  def create
    super
    if !current_user.profiles.first
      current_user.profiles.create
    end
  end

  def update
    super
  end

end 