module AlfacesBot
  class Parser
    MINUTES_REGEX = /me lembre em (?<minutes>-?\d+) minutos? de (?<task>.*)$/i
    HOURS_REGEX = /me lembre em (?<hours>\d+) horas? de (?<task>.*)$/i
    DAYS_REGEX = /me lembre em (?<days>\d+) dias? de (?<task>.*)$/i
    DATE_TIME_REGEX = /me lembre em (?<date>\d\d\/\d\d \d\d:\d\d) de (?<task>.*)$/i
    TASK_WITHOUT_TIME_REGEX = /me lembre de (?<task>.*)$/i
    TO_DO_LIST_REGEX = /^(todos?|to-dos?)/i

    attr_accessor :memory

    def initialize(memory)
      self.memory = memory
    end

    def parse(command)
       case command
       when MINUTES_REGEX
         Task.new(task: $~[:task], notify_at: $~[:minutes].to_i.minutes.from_now)
       when HOURS_REGEX
         Task.new(task: $~[:task], notify_at: $~[:hours].to_i.hours.from_now)
       when DAYS_REGEX
         Task.new(task: $~[:task], notify_at: $~[:days].to_i.days.from_now)
       when DATE_TIME_REGEX
         Task.new(task: $~[:task], notify_at: Time.strptime($~[:date], "%d/%m %H:%M"))
       when TASK_WITHOUT_TIME_REGEX
         Task.new(task: $~[:task], notify_at: nil)
       when TO_DO_LIST_REGEX
         to_do_list = memory.to_do_list
         return 'You have nothing to do' unless to_do_list.to_a.size > 0
         to_do_list.map.with_index do |task, index|
           "#{index + 1}) #{task[:task]}"
         end.join("\n")
       when /greet/i
         'Hello!'
       else
         'have no idea what it means.'
       end
    end
  end
end
