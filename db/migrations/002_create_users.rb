Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :username, size: 32, null: false, unique: true
      String :password_digest, size: 255, null: false
      String :email, size: 64
      String :about, text: true, size: 500
      String :avatar_data, text: true
      String :reset_pwd_token, size: 255
      DateTime :reset_pwd_token_sent_at
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
