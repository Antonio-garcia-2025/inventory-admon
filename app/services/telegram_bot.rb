class TelegramBot
  include HTTParty
  base_uri "https://api.telegram.org/bot"

  def initialize
    @token = ENV["TELEGRAM_BOT_TOKEN"]
  end

  def send_message(chat_id, text)
    self.class.post("/#{@token}/sendMessage", body: {
      chat_id: chat_id,
      text: text,
      parse_mode: "Markdown"
    })
  end
end
