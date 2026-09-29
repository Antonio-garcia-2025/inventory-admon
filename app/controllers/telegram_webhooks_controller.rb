class TelegramWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def receive
    if params[:message].present?
      chat_id = params[:message][:chat][:id].to_s 
      texto_usuario = params[:message][:text].to_s.strip
      usuario_actual = User.find_by(telegram_chat_id: chat_id)
      
      # Creamos una variable para saber si debemos mostrar el teclado
      mostrar_botones = false

      if texto_usuario.start_with?('/vincular')
        correo = texto_usuario.split(' ')[1]
        
        if correo.present?
          usuario_encontrado = User.find_by(email: correo)
          
          if usuario_encontrado
            User.where(telegram_chat_id: chat_id).update_all(telegram_chat_id: nil)
            usuario_encontrado.update(telegram_chat_id: chat_id)
            
            respuesta = "✅ ¡Cuenta vinculada exitosamente!\n\nUsa el nuevo botón en tu teclado para consultar tus productos."
            mostrar_botones = true # Activamos el botón porque ya se vinculó
          else
            respuesta = "❌ No encontré ningún usuario con el correo #{correo}. Verifica que esté bien escrito."
          end
        else
          respuesta = "⚠️ Para vincular tu cuenta, escribe /vincular seguido de tu correo."
        end

      elsif texto_usuario == '/start'
        respuesta = "¡Hola! Soy el bot de inventary-admon.\nPara empezar, vincula tu cuenta escribiendo:\n/vincular tu_correo@ejemplo.com"
        
      # Fíjate cómo ahora aceptamos el comando /stock O el texto que envía el botón
      elsif texto_usuario == '/stock' || texto_usuario == '📦 Consultar Inventario'
        if usuario_actual
          productos = usuario_actual.products 
          mostrar_botones = true # Mantenemos el botón visible
          
          if productos.any?
            respuesta = "📦 <b>Tu Inventario Actual:</b>\n\n"
            productos.each do |p|
              respuesta += "• #{p.name}: #{p.stock} unidades ($#{p.price})\n"
            end
          else
            respuesta = "Tu inventario está vacío en este momento."
          end
        else
          respuesta = "🔒 Primero debes vincular tu cuenta para ver tu inventario. Escribe:\n/vincular tu_correo@ejemplo.com"
        end
        
      else
        respuesta = "No reconozco ese comando."
        mostrar_botones = true if usuario_actual
      end

      # Enviamos la respuesta junto con la instrucción de mostrar (o no) los botones
      bot = TelegramBot.new
      bot.send_message(chat_id, respuesta, mostrar_botones)
    end

    head :ok
  end
end