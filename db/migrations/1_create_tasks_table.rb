Sequel.migration do
  change do
    create_table(:tasks) do
      primary_key :id
      String :chat_id, :null => false
      String :task, :null => false, :size => 255
      Bool :notified, :default => false
      DateTime :notify_at, :null => false
    end
  end
end

