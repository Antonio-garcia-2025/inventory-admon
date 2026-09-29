class TelegramWebhooksController < ApplicationController
  # Configuraciones de seguridad a nivel de clase (fuera de los métodos)
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def receive
    # 1. Telegram nos manda un paquete de datos (params) gigante.
    # Primero verificamos si el paquete realmente contiene un "message".
    if params[:message].present?
      
      # 2. Extraemos quién nos escribe (su ID de chat) para saber a quién responderle
      chat_id = params[:message][:chat][:id]
      
      # 3. Extraemos lo que nos escribió (el texto)
      texto_usuario = params[:message][:text]

      # 4. Por ahora, como prueba, vamos a hacer que el bot sea un "eco".
      respuesta = "Hola, soy tu inventario. Recibí este mensaje: '#{texto_usuario}'"

      # 5. Llamamos al "Mensajero"
      bot = TelegramBot.new
      bot.send_message(chat_id, respuesta)
    end

    # 6. Al final, SIEMPRE debemos decirle a Telegram: "Todo en orden, código 200 (ok)".
    head :ok
  end
end