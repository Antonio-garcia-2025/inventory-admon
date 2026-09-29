# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

run Rails.application
Rails.application.load_server
# Esta ruta recibe peticiones POST de Telegram.
  # Le dice a Rails: "Si alguien manda datos a '/telegram_webhook', 
  # envíalos al controlador 'telegram_webhooks' y ejecuta el método 'receive'".
  post '/telegram_webhook', to: 'telegram_webhooks#receive'
