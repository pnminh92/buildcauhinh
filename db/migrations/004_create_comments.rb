Sequel.migration do
  change do
    create_table(:comments) do
      primary_key :id
      foreign_key :user_id, :users, null: false
      foreign_key :build_id, :builds, null: false
      String :content, text: true, size: 500, null: false
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
