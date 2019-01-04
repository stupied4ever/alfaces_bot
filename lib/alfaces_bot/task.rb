module AlfacesBot
  class Task < Sequel::Model
    def text
      if notify_at
        "#{task} [#{notify_at.strftime("%d-%m %H:%M")}]"
      else
        task
      end
    end
  end
end
