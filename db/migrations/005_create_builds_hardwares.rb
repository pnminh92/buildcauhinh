Sequel.migration do
  change do
    create_table(:builds_hardwares) do
      primary_key :id
      Integer :build_id, null: false
      Integer :hardware_id, null: false
      index [:build_id, :hardware_id], unique: true
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
