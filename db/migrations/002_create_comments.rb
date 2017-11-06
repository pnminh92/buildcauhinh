Sequel.migration do
  change do
    create_table(:comments) do
      primary_key :id
      Integer :user_id, null: false, index: true
      Integer :build_id, null: false, index: true
      String :content, text: true, size: 500, null: false
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
