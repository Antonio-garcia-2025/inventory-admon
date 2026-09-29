class TelegramWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def receive
    if params[:message].present?
      # Guardamos el ID como texto (string) por seguridad, ya que los IDs de Telegram son números muy grandes
      chat_id = params[:message][:chat][:id].to_s 
      texto_usuario = params[:message][:text].to_s.strip

      # 1. Identificamos si el chat ya pertenece a un usuario en la base de datos
      usuario_actual = User.find_by(telegram_chat_id: chat_id)

      # 2. Lógica de comandos
      if texto_usuario.start_with?('/vincular')
        # Separamos el comando del correo (Ej. "/vincular admin@correo.com")
        correo = texto_usuario.split(' ')[1]
        
        if correo.present?
          usuario_encontrado = User.find_by(email: correo)
          
          if usuario_encontrado
            usuario_encontrado.update(telegram_chat_id: chat_id)
            respuesta = "✅ ¡Cuenta vinculada exitosamente! Tu correo #{correo} ya está conectado. Escribe /stock para ver tus productos."
          else
            respuesta = "❌ No encontré ningún usuario con el correo #{correo}. Verifica que esté bien escrito."
          end
        else
          respuesta = "⚠️ Para vincular tu cuenta, escribe /vincular seguido de tu correo.\nEjemplo: /vincular mi_correo@ejemplo.com"
        end

      elsif texto_usuario == '/start'
        respuesta = "¡Hola! Soy el bot de inventary-admon.\nPara empezar, vincula tu cuenta escribiendo:\n/vincular tu_correo@ejemplo.com"
        
      elsif texto_usuario == '/stock'
        if usuario_actual
          # Ahora solo traemos los productos de ESTE usuario, no los de toda la base de datos
          productos = usuario_actual.products 
          
          if productos.any?
            respuesta = "📦 *Tu Inventario Actual:*\n\n"
            productos.each do |p|
              respuesta += "• #{p.name}: #{p.stock} unidades ($#{p.price})\n"
            end
          else
            respuesta = "Tu inventario está vacío en este momento."
          end
        else
          # Si no está vinculado, le negamos el acceso al stock
          respuesta = "🔒 Primero debes vincular tu cuenta para ver tu inventario. Escribe:\n/vincular tu_correo@ejemplo.com"
        end
        
      else
        respuesta = "No reconozco ese comando. Intenta con /stock o /vincular"
      end

      bot = TelegramBot.new
      bot.send_message(chat_id, respuesta)
    end

    head :ok
  end
end