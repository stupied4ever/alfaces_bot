module AlfacesBot
  class Memory
    attr_accessor :chat_id

    def initialize(chat_id)
      self.chat_id = chat_id
    end

    def to_do_list
      Task
        .where(chat_id: self.chat_id.to_s, notified: false, done_at: nil)
        .where{ (notify_at == nil) | (notify_at > Time.now) }
        .order(Sequel.desc(:notify_at), Sequel.desc(:id))
    end

    def done(id)
      DB[:tasks].where(id: id).update(done_at: Time.now)
    end
  end
end
