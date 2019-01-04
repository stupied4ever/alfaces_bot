module AlfacesBot
  class Parser
    MINUTES_REGEX = /(\/todo (?<minutes>-?\d+)m|me lembre em (?<minutes>-?\d+) minutos? de) (?<task>.*)$/i
    HOURS_REGEX = /(\/todo (?<hours>-?\d+)h|me lembre em (?<hours>-?\d+) horas? de) (?<task>.*)$/i
    DAYS_REGEX = /(\/todo (?<days>-?\d+)d|me lembre em (?<days>-?\d+) dias? de) (?<task>.*)$/i
    DATE_TIME_REGEX = /(\/todo (?<date>\d\d\/\d\d \d\d:\d\d)|me lembre em (?<date>\d\d\/\d\d \d\d:\d\d) de) (?<task>.*)$/i
    TASK_WITHOUT_TIME_REGEX = /(\/todo|me lembre de) (?<task>.*)$/i
    DONE_TASK = 'What task you have done?'

    attr_accessor :memory

    def initialize(memory)
      self.memory = memory
    end

    def parse(message)
      case message
      when Telegram::Bot::Types::CallbackQuery
        case message.message.text
        when DONE_TASK
          memory.done(message.data.to_i)
          return list_pending_tasks
        end
      else
        case message.text
        when MINUTES_REGEX
          return Task.new(task: $~[:task], notify_at: $~[:minutes].to_i.minutes.from_now)
        when HOURS_REGEX
          return Task.new(task: $~[:task], notify_at: $~[:hours].to_i.hours.from_now)
        when DAYS_REGEX
          return Task.new(task: $~[:task], notify_at: $~[:days].to_i.days.from_now)
        when DATE_TIME_REGEX
          return Task.new(task: $~[:task], notify_at: Time.strptime($~[:date], "%d/%m %H:%M"))
        when TASK_WITHOUT_TIME_REGEX
          return Task.new(task: $~[:task], notify_at: nil)
        when '/to-do', '/todo'
          return list_pending_tasks
        when /greet/i
          return { text: 'Hello!' }
        else
          return { text: 'I have no idea what it means.' }
        end
      end
    end

    private def list_pending_tasks
      to_do_list = memory.to_do_list
      return { text: 'You have no pending tasks' } if to_do_list.to_a.size == 0

      options = to_do_list.map do |task|
        Telegram::Bot::Types::InlineKeyboardButton.new(
          text: task.text,
          callback_data: task[:id]
        )
      end
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: options)

      return { text: DONE_TASK, reply_markup: markup }
    end
  end
end
