Markdown
# Inventary-Admon

[English version below](#english-version)

Un sistema robusto de gestión de inventarios desarrollado con Ruby on Rails, que cuenta con la integración de un bot de Telegram. Esta aplicación permite a los usuarios registrados vincular de forma segura sus cuentas y consultar las existencias y precios de sus productos en tiempo real mediante un chat interactivo.

## Características

* Arquitectura Multi-usuario: Cada usuario gestiona y consulta exclusivamente su propio inventario.
* Integración con Telegram: Comunicación segura mediante webhooks entre la API de Telegram y el servidor de Rails.
* Vinculación de Cuentas: Los usuarios pueden enlazar su cuenta web con su identificador de chat de Telegram utilizando el comando /vincular.
* Menús Interactivos: Teclado personalizado en formato HTML dentro de Telegram para consultas rápidas de inventario sin necesidad de escribir comandos manualmente.
* Widget Flotante: Un botón de interfaz de usuario en la aplicación web que redirige directamente al bot de Telegram.

## Tecnologías Utilizadas

* Backend: Ruby on Rails
* Base de Datos: PostgreSQL
* Peticiones API: HTTParty
* Despliegue: Render

## Configuración e Instalación

1. Clonar el repositorio:
   ```bash
   git clone [https://github.com/Antonio-garcia-2025/inventary-admon.git](https://github.com/Antonio-garcia-2025/inventary-admon.git)
   cd inventary-admon
Instalar dependencias:

Bash
bundle install
Configuración de la base de datos:
Ejecutar los siguientes comandos para crear la base de datos y correr las migraciones (incluyendo la columna telegram_chat_id para los usuarios):

Bash
rails db:create
rails db:migrate
Variables de Entorno:
Es necesario configurar el token del bot de Telegram. Agrégalo a las variables de entorno en Render, o localmente usando:

Plaintext
TELEGRAM_BOT_TOKEN=tu_token_aqui
Configuración del Webhook:
Para conectar el bot a la aplicación, visita la siguiente URL en tu navegador, reemplazando los valores por tu Token y tu URL de Render:
https://api.telegram.org/bot<TU_TOKEN>/setWebhook?url=https://<TU_URL_DE_RENDER>/telegram_webhook

Comandos del Bot de Telegram
/start - Muestra el mensaje de bienvenida y las instrucciones del sistema.

/vincular [tu_correo@ejemplo.com] - Enlaza el chat actual de Telegram con la cuenta de usuario especificada en la base de datos.

/stock (o mediante el botón del teclado) - Obtiene y muestra las existencias y precios actuales del inventario del usuario.

Licencia
Este proyecto es de código abierto y está disponible bajo la Licencia MIT.


Te invito a visitar y probar la implementación:
https://shopify-z885.onrender.com/