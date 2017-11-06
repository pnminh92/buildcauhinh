Sequel.migration do
  change do
    extension :pg_enum
    create_enum(:provider_type, %w[mai_hoang ha_noi_computer ha_noi_new tan_doanh phong_vu nam_an])

    create_table(:hardwares) do
      primary_key :id
      provider_type :provider, null: false
      String :code, fixed: true, null: false, index: { unique: true }
      String :name, fixed: true, null: false
      String :url, fixed: true, null: false
      String :image, fixed: true, null: false
      Integer :price, null: false
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
