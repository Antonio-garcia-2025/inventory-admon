class TelegramWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def receive
    if params[:message].present?
      chat_id = params[:message][:chat][:id]
      texto_usuario = params[:message][:text]

      case texto_usuario
      when '/start'
        respuesta = "¡Hola! Soy el bot de tu sistema inventary-admon. Escribe /stock para consultar las existencias."
        
      when '/stock'
        # Usamos el modelo exacto que corresponde a la tabla "products"
        productos = Product.all 
        
        if productos.any?
          respuesta = "📦 *Inventario Actual:*\n\n"
          
          productos.each do |p|
            # Usamos los nombres exactos de tus columnas: name, stock y price
            respuesta += "• #{p.name}: #{p.stock} unidades ($#{p.price})\n"
          end
        else
          respuesta = "El inventario está vacío en este momento."
        end
        
      else
        respuesta = "No reconozco ese comando. Intenta con /stock"
      end

      bot = TelegramBot.new
      bot.send_message(chat_id, respuesta)
    end

    head :ok
  end
end