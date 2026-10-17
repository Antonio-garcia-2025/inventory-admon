class ChatController < ApplicationController
  def index
  end

  def preguntar
    mensaje_del_usuario = params[:mensaje]
    @respuesta_del_bot = ChatBotService.enviar_mensaje(mensaje_del_usuario)
    
    # LA CLAVE: Responder en formato JSON explícitamente
    render json: { respuesta: @respuesta_del_bot }
  end
end