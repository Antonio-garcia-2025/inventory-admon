class TelegramWebhooksController < ApplicationController
  # Por seguridad, Rails bloquea peticiones externas que no vienen de tus propios formularios HTML.
  # Como esta petición viene de los servidores de Telegram, le decimos a Rails que la deje pasar.
skip_before_action :verify_authenticity_token
  def receive
    # 1. Telegram nos manda un paquete de datos (params) gigante.
    # Primero verificamos si el paquete realmente contiene un "message".
    if params[:message].present?
      
      # 2. Extraemos quién nos escribe (su ID de chat) para saber a quién responderle
      chat_id = params[:message][:chat][:id]
      
      # 3. Extraemos lo que nos escribió (el texto)
      texto_usuario = params[:message][:text]

      # 4. Por ahora, como prueba, vamos a hacer que el bot sea un "eco".
      # Va a responder diciendo: "Recibí tu mensaje, dijiste: [lo que sea que escribiste]"
      respuesta = "Hola, soy tu inventario. Recibí este mensaje: '#{texto_usuario}'"

      # 5. Llamamos al "Mensajero" (el archivo que creamos en el paso anterior)
      # Le damos el ID del chat y el texto que queremos enviar.
      bot = TelegramBot.new
      bot.send_message(chat_id, respuesta)
    end

    # 6. Al final, SIEMPRE debemos decirle a Telegram: "Todo en orden, código 200 (ok)".
    # Si no hacemos esto, Telegram pensará que hubo un error y nos reenviará el mensaje muchas veces.
    head :ok
  end
end