module AlfacesBot
  class Parser
    MINUTES_REGEX = /me lembre em (?<minutes>\d+) minutos? de (?<task>.*)$/i
    HOURS_REGEX = /me lembre em (?<hours>\d+) horas? de (?<task>.*)$/i
    DAYS_REGEX = /me lembre em (?<days>\d+) dias? de (?<task>.*)$/i

    def parse(command)
       case command
       when MINUTES_REGEX
         Task.new(task: $~[:task], notify_at: $~[:minutes].to_i.minutes.from_now)
       when HOURS_REGEX
         Task.new(task: $~[:task], notify_at: $~[:hours].to_i.hours.from_now)
       when DAYS_REGEX
         Task.new(task: $~[:task], notify_at: $~[:days].to_i.days.from_now)
       when /greet/i
         "Hello, #{message.from.first_name}!"
       else
         "#{message.from.first_name}, have no idea what #{command.inspect} means."
       end
    end
  end
end
