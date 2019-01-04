Sequel.migration do
  change do
    alter_table(:tasks) do
      add_column :done_at, DateTime
    end
  end
end

