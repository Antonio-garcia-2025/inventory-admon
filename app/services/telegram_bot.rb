class TelegramBot
  include HTTParty
  # Quitamos el "/bot" de aquí para evitar diagonales duplicadas
  base_uri "https://api.telegram.org"

  def initialize
    # Intentará usar la variable de entorno, pero si Render no la tiene, usará tu token directamente para que funcione sí o sí.
    @token = ENV["TELEGRAM_BOT_TOKEN"].presence || "8743639632:AAFdSPNwCSPJWelh4NVQx-53ba9fbalDdZ4"
  end

  def send_message(chat_id, text)
    # Pegamos la palabra bot directamente al token como lo exige Telegram
    respuesta = self.class.post("/bot#{@token}/sendMessage", body: {
      chat_id: chat_id,
      text: text,
      parse_mode: "Markdown"
    })
    
    # Esto imprimirá en los logs de Render exactamente qué responde Telegram al intentar enviar
    puts "=== RESPUESTA DE TELEGRAM AL ENVIAR: #{respuesta.body} ==="
  end
end