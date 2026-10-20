# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class ChatBotService
  API_URL = 'https://api-respuestas-chat.onrender.com/predecir'

  def self.enviar_mensaje(texto_usuario)
    uri = URI.parse(API_URL)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, { 'Content-Type' => 'application/json' })
    request.body = { texto: texto_usuario }.to_json

    begin
      response = http.request(request)
      resultado = JSON.parse(response.body)

      respuesta_ia = resultado['respuesta']
      intencion = resultado['intencion']

      case intencion
      when 'consultar_catalogo'
        productos = Product.limit(3).map { |p| "• #{p.name} - $#{p.price}" }.join("\n")
        "¡Claro! Aquí tienes algunos de nuestros productos más populares:\n\n#{productos}"
      when 'contacto'
        "#{respuesta_ia}\n\nNuestro correo de soporte es soporte@tutienda.com"
      else
        respuesta_ia
      end
    rescue JSON::ParserError
      "Error de formato de la IA. Respuesta de Render: #{response.body}"
    rescue StandardError => e
      "Error de conexión con la IA: #{e.message}"
    end
  end
end
