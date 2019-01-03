module AlfacesBot
  class Runner
   MINUTES_REGEX = /me lembre em (?<minutes>\d+) minutos? de (?<task>.*)$/i
   HOURS_REGEX = /me lembre em (?<hours>\d+) horas? de (?<task>.*)$/i
   DAYS_REGEX = /me lembre em (?<days>\d+) dias? de (?<task>.*)$/i

   def while_true(bot)
     tasks_to_notify.each do |task|
       notify(bot, task)
     end

     messages = bot.get_updates(fail_silently: true)
     messages.compact.each do |message|
       proccess_message(bot, message)
     end

     while_true(bot)
   end

   def tasks_to_notify
     DB[:tasks].where(notified: false).where{ notify_at < Time.now }.order(Sequel.desc(:notify_at))
   end

   def notify(bot, task)
     channel = TelegramBot::Channel.new(id: task[:chat_id])
     message = TelegramBot::OutMessage.new
     message.chat = channel
     message.text = "You asked me to remember about: #{task[:task]}"
     message.send_with(bot)

     DB[:tasks].where(id: task[:id]).update(notified: true)
   end

   def proccess_message(bot, message)
     command = message.get_command_for(bot)

     parser = Parser.new
     message.reply do |reply|
       parsed_content = parser.parse(command)
       if parsed_content.is_a?(Task)
         schedule_for_notification(message, parsed_content)
         reply.text = "Ok, I can do it for you."
       else
         reply.text = parsed_content
       end
       reply.send_with(bot)
     end
   end

   def schedule_for_notification(message, task)
     DB[:tasks].insert(task: task.task, chat_id: message.chat.id, notify_at: task.notify_at)
   end

   def run
     bot = TelegramBot.new(token: ENV.fetch('TELEGRAM_TOKEN'))
     while_true(bot)
   end
 end
end
