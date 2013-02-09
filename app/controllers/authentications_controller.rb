class AuthenticationsController < InheritedResources::Base
  
  def index   
    @authentications = current_user.authentications if current_user
  end

  # GET /auth/:provider/callback
  def create 
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication #existe la autenticacion
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user #añadir auteticacion al usuario existente
      current_user.authentications.create(:provider => omniauth ['provider'], :uid => omniauth['uid'], uname: omniauth['extra']['raw_info']['username'], uemail: omniauth['extra']['raw_info']['email'])
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    elsif omniauth[:info][:email].blank?
        # Get session ready to redirect_to registration form
        session[:omniauth] = omniauth.except('extra')
        flash[:alert] = "Por favor, completa el formulario de registro"
        redirect_to new_user_registration_path
    else #si no existe el usuario
      @user = User.new(name: omniauth[:info][:name], email: omniauth[:info][:email], password:Devise.friendly_token[0,20])
      @user.save!
      @user.authentications.create(:provider => omniauth ['provider'], :uid => omniauth['uid'], uname: omniauth['extra']['raw_info']['username'], uemail: omniauth['extra']['raw_info']['email'])
      if @user.save
        flash[:notice] = "Signed in successfully. Change your password"
        sign_in_and_redirect(:user, @user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end
  
  # GET /auth/failure
  def failure
    redirect_to root_url, notice: 'Ha ocurrido un error.'
  end
  
  # GET /auth/sign_out
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
  
end
