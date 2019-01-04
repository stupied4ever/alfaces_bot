module AlfacesBot
  class Memory
    attr_accessor :chat_id

    def initialize(chat_id)
      self.chat_id = chat_id
    end

    def to_do_list
      DB[:tasks].where(chat_id: self.chat_id.to_s, notify_at: nil).order(Sequel.desc(:id))
    end


  end
end
