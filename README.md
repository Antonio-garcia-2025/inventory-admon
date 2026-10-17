# Inventory Admon & AI Chatbot

*Read this in [Spanish](README.es.md).*

An e-commerce platform built with Ruby on Rails, powered by a Python Artificial Intelligence microservice for automated customer support.

## System Architecture
The project utilizes a microservices architecture to separate business logic from Natural Language Processing (NLP):
* **Frontend / Main Backend:** Monolith in Ruby on Rails (MVC). Manages the product database, user interface, and shopping cart logic.
* **AI Microservice:** RESTful API built with FastAPI and hosted on Render.
* **Machine Learning Engine:** Classification model trained with Scikit-Learn (Logistic Regression + TF-IDF) to predict user intent.

## Interaction Flow
1. The user sends a message through the interface (Turbo/Hotwire) in Rails.
2. `ChatBotService` (Rails) sends an encrypted HTTPS request to the Python microservice.
3. The **Scikit-Learn** model vectorizes the text, predicts the mathematical intent, and returns it to Rails.
4. Rails intercepts the intent (e.g., `view_catalog`), queries the PostgreSQL/SQLite database, and dynamically renders the products in the chat.

## Technologies Used
* **Backend:** Ruby 3.x, Rails 7, PostgreSQL/SQLite.
* **AI & Data Science:** Python 3, FastAPI, Uvicorn, Scikit-Learn, Pandas.
* **Deployment:** Render (AI Microservice), GitHub (Version Control).
* **Frontend:** HTML5, CSS3, JavaScript, Turbo (Hotwire).

## How to run locally
1. Clone the repository: `git clone https://github.com/Antonio-garcia-2025/inventory-admon.git`
2. Install Rails gems: `bundle install`
3. Configure the database: `rails db:migrate db:seed`
4. Start the server: `rails server`
*(Note: The AI microservice is deployed in the cloud, so the chat will work immediately with an internet connection).*