class TelegramBot
  include HTTParty
  base_uri "https://api.telegram.org"

  def initialize
    @token = ENV["TELEGRAM_BOT_TOKEN"].presence || ""
  end

  # Agregamos un tercer parámetro opcional llamado 'mostrar_botones'
  def send_message(chat_id, text, mostrar_botones = false)
    cuerpo = {
      chat_id: chat_id,
      text: text,
      parse_mode: "HTML"
    }

    # Si le decimos al código que muestre botones, agrega el teclado a la respuesta
    if mostrar_botones
      cuerpo[:reply_markup] = {
        keyboard: [
          [{ text: "📦 Consultar Inventario" }] # Puedes agregar más botones aquí en el futuro
        ],
        resize_keyboard: true, # Hace que el botón sea más delgado y estético
        one_time_keyboard: false
      }
    end

    # Usamos .to_json y declaramos el Content-Type para que Telegram entienda el teclado
    respuesta = self.class.post("/bot#{@token}/sendMessage", 
      headers: { 'Content-Type' => 'application/json' },
      body: cuerpo.to_json
    )
    
    puts "=== RESPUESTA DE TELEGRAM AL ENVIAR: #{respuesta.body} ==="
  end
end