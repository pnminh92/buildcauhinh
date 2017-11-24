Sequel.migration do
  change do
    extension :pg_enum
    create_enum(:cpu_type, %w[intel amd])

    create_table(:builds) do
      primary_key :id
      foreign_key :user_id, :users, null: false
      String :slug, size: 255, null: false, index: { unique: true }
      String :title, size: 255, null: false
      String :description, text: true, size: 500
      Integer :total_price, null: false
      cpu_type :cpu_type
      TrueClass :price_showed, null: false, default: true
      TrueClass :provider_showed, null: false, default: false
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
