# Inventory Admon & AI Chatbot

Una plataforma de e-commerce construida con Ruby on Rails, impulsada por un microservicio de Inteligencia Artificial en Python para atención al cliente automatizada.

## Arquitectura del Sistema
El proyecto utiliza una arquitectura de microservicios para separar la lógica de negocio del procesamiento de lenguaje natural (NLP):
* **Frontend / Backend Principal:** Monolito en Ruby on Rails (MVC). Gestiona la base de datos de productos, la interfaz de usuario y la lógica de carrito de compras.
* **Microservicio de IA:** API RESTful construida con FastAPI y alojada en Render.
* **Motor de Machine Learning:** Modelo de clasificación entrenado con Scikit-Learn (Logistic Regression + TF-IDF) para predecir la intención del usuario.

## Flujo de Interacción
1. El usuario envía un mensaje a través de la interfaz (Turbo/Hotwire) en Rails.
2. `ChatBotService` (Rails) envía una petición HTTPS cifrada al microservicio en Python.
3. El modelo de **Scikit-Learn** vectoriza el texto, predice la intención matemática y la devuelve a Rails.
4. Rails intercepta la intención (ej. `ver_catalogo`), consulta la base de datos PostgreSQL/SQLite y renderiza los productos dinámicamente en el chat.

## Tecnologías Utilizadas
* **Backend:** Ruby 3.x, Rails 7, PostgreSQL/SQLite.
* **IA & Data Science:** Python 3, FastAPI, Uvicorn, Scikit-Learn, Pandas.
* **Despliegue:** Render (Microservicio IA), GitHub (Control de versiones).
* **Frontend:** HTML5, CSS3, JavaScript, Turbo (Hotwire).

## Cómo ejecutar en local
1. Clona el repositorio: `git clone https://github.com/Antonio-garcia-2025/inventory-admon.git`
2. Instala las gemas de Rails: `bundle install`
3. Configura la base de datos: `rails db:migrate db:seed`
4. Inicia el servidor: `rails server`
*(Nota: El microservicio de IA está desplegado en la nube, por lo que el chat funcionará inmediatamente con conexión a internet).*