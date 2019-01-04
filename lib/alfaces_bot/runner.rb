module AlfacesBot
  class Runner
    MINUTES_REGEX = /me lembre em (?<minutes>\d+) minutos? de (?<task>.*)$/i
    HOURS_REGEX = /me lembre em (?<hours>\d+) horas? de (?<task>.*)$/i
    DAYS_REGEX = /me lembre em (?<days>\d+) dias? de (?<task>.*)$/i

    def while_true(bot)
      tasks_to_notify.each do |task|
        notify(bot, task)
      end

      bot.fetch_updates do |message|
        proccess_message(bot, message)
      end

      while_true(bot)
    end

    def tasks_to_notify
      p Time.now
      DB[:tasks].where(notified: false).where{ notify_at < Time.now }.order(Sequel.desc(:notify_at))
    end

    def notify(bot, task)
      bot.api.send_message(chat_id: task[:chat_id], text: "You asked me to remember about: #{task[:task]}")

      DB[:tasks].where(id: task[:id]).update(notified: true)
    end

    def proccess_message(bot, message)
      memory = Memory.new(message.chat.id)
      parser = Parser.new(memory)

      parsed_content = parser.parse(message.text)
      if parsed_content.is_a?(Task)
        schedule_for_notification(message, parsed_content)

        bot.api.send_message(chat_id: message.chat.id, text: 'Ok, I can do it for you.')
      else
        bot.api.send_message(chat_id: message.chat.id, text: parsed_content)
      end
    end

    def schedule_for_notification(message, task)
      DB[:tasks].insert(task: task.task, chat_id: message.chat.id, notify_at: task.notify_at)
    end

    def run
      Telegram::Bot::Client.run(ENV.fetch('TELEGRAM_TOKEN')) do |bot|
        while_true(bot)
      end
    end
  end
end
