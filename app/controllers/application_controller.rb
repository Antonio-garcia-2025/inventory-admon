class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Permite :username al momento del registro
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    # Permite actualizar :username desde la edición de perfil
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end