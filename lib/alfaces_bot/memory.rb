module AlfacesBot
  class Memory
    attr_accessor :chat_id

    def initialize(chat_id)
      self.chat_id = chat_id
    end

    def to_do_list
      Task
        .where(chat_id: self.chat_id.to_s, done_at: nil)
        .order(Sequel.desc(:notify_at), Sequel.desc(:id))
    end

    def done(id)
      DB[:tasks].where(id: id).update(done_at: Time.now)
    end
  end
end
