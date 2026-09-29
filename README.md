A robust inventory management system built with Ruby on Rails, featuring a fully integrated Telegram bot. This application allows registered users to securely bind their Telegram accounts and check their personal product stock and prices in real-time through an interactive Telegram chat.

Features
Multi-User Architecture: Each user manages and queries their own inventory exclusively.

Telegram Bot Integration: Secure webhook communication between Telegram APIs and the Rails backend.

Account Binding: Users can link their web account to their Telegram chat ID using the /vincular  command.

Interactive Menus: Custom Telegram HTML keyboard buttons for quick stock consultation without manually typing commands.

Floating Widget: A direct floating UI button in the web application that redirects users to the Telegram bot.

Tech Stack
Backend: Ruby on Rails

Database: PostgreSQL

API Requests: HTTParty

Deployment: Render

Setup and Installation
Clone the repository:

Bash
git clone [https://github.com/Antonio-garcia-2025/inventary-admon.git](https://github.com/Antonio-garcia-2025/inventary-admon.git)
cd inventary-admon
Install dependencies:

Bash
bundle install
Database Setup:
Run the following commands to create the database and run the migrations (including the telegram_chat_id column for users):

Bash
rails db:create
rails db:migrate
Environment Variables:
You need to set up your Telegram Bot token. Add it to your environment variables in Render, or locally, using:

Plaintext
TELEGRAM_BOT_TOKEN=your_bot_token_here
Set up the Webhook:
To connect your bot to the application, manually visit the following URL in your browser, replacing the placeholders with your actual Bot Token and Render URL:
https://api.telegram.org/bot<YOUR_BOT_TOKEN>/setWebhook?url=https://<YOUR_RENDER_URL>/telegram_webhook

Telegram Bot Commands
/start - Displays the welcome message and instructions.

/vincular [your_email@example.com] - Links the current Telegram chat to the specified user account in the database.

/stock (or using the custom keyboard button) - Fetches and displays the user's current inventory stock and prices.

License
This project is open-source and available under the MIT License.

I invite you to visit and try out the deployment:
https://shopify-z885.onrender.com/