class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_locale
  
  def set_locale
    if params[:locale]
      session[:locale] = params[:locale]
    end
    session[:locale] = I18n.default_locale unless session[:locale]
    
    I18n.locale = session[:locale]
  end
  
end
