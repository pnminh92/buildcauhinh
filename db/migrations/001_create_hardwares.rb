Sequel.migration do
  change do
    extension :pg_enum
    create_enum(:provider_type, %w[mai_hoang ha_noi_computer ha_noi_new tan_doanh phong_vu nam_an])

    create_table(:hardwares) do
      primary_key :id
      provider_type :provider, null: false
      String :code, size: 255, null: false, index: { unique: true }
      String :name, size: 255, null: false
      String :url, size: 255, null: false
      String :image_url, size: 255, null: false
      Integer :price, null: false
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
