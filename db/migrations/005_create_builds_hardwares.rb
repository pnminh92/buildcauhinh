Sequel.migration do
  change do
    create_table(:builds_hardwares) do
      foreign_key :build_id, :builds, null: false
      foreign_key :hardware_id, :hardwares, null: false
      primary_key [:build_id, :hardware_id]
      index [:build_id, :hardware_id]
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
