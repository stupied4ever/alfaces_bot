module AlfacesBot
  class Memory
    attr_accessor :chat_id

    def initialize(chat_id)
      self.chat_id = chat_id
    end

    def to_do_list
      DB[:tasks].where(chat_id: self.chat_id.to_s, notify_at: nil, done_at: nil).order(Sequel.desc(:id))
    end

    def done(id)
      DB[:tasks].where(id: id).update(done_at: Time.now)
    end


  end
end
