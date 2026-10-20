# frozen_string_literal: true

class ChatController < ApplicationController
  def preguntar
    mensaje_del_usuario = params[:mensaje]
    @respuesta_del_bot = ChatBotService.enviar_mensaje(mensaje_del_usuario)

    render json: { respuesta: @respuesta_del_bot }
  end
end
