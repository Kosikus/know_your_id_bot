require 'telegram/bot'
require 'dotenv' # для добавления в переменные окружения секретных данных

# Загрузка переменных окружения (значение Token бота, имя и пароль к почте яндекса)
Dotenv.load

# Замените на ваш токен
TOKEN = ENV['TELEGRAM_BOT_TOKEN']
# Замените на ваш ID (ID вашего чата в боте)
MY_CHAT_ID = ENV['MY_CHAT_ID']

def log_user_data(user)
  # Записываем данные пользователя в файл
  File.open('./data/user_data.txt', 'a') do |file|
    file.puts "ID: #{user.id}, Username: #{user.username || 'no username'}"
  end
end

Telegram::Bot::Client.run(TOKEN) do |bot|
  puts "Бот запущен..."

  bot.listen do |message|
    case message.text
    when '/start'
      user = message.from
      log_user_data(user)
      
      # Сообщаем пользователю, что его данные сохранены
      bot.api.send_message(chat_id: message.chat.id, text: "Привет, #{user.first_name}!\nВаши данные записаны ✍\nID: #{user.id}, Username: #{user.username || 'нет username'}")

      # Отправляем данные пользователя в ваш чат
      bot.api.send_message(chat_id: MY_CHAT_ID, text: "Новый пользователь: ID: #{user.id}, Username: #{user.username || 'нет username'}")
    end
  end
end