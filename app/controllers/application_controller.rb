# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  # permite usar el metodo tanto en controladores como en .arb
  helper_method :current_cart

  def current_cart
    return nil unless user_signed_in?

    # busca el carrito del usuario y crea uno si no existe.
    @current_cart ||= current_user.cart || current_user.create_cart
  end

  protected

  def configure_permitted_parameters
    # Permite :username al momento del registro
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    # Permite actualizar :username desde la edición de perfil
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
