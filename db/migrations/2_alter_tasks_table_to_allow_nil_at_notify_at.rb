Sequel.migration do
  change do
    alter_table(:tasks) do
      set_column_allow_null :notify_at
    end
  end
end

