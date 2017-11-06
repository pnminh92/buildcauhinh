Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :username, size: 32, null: false, unique: true
      String :password_digest, fixed: true, null: false
      String :email, size: 64
      String :about, text: true, size: 500
      String :avatar_url, size: 500, null: false
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
