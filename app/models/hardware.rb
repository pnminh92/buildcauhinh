# Table: hardwares
# Columns:
#  id         | integer                     | PRIMARY KEY DEFAULT nextval('hardwares_id_seq'::regclass)
#  provider   | provider_type               | NOT NULL
#  code       | character(255)              | NOT NULL
#  name       | character(255)              | NOT NULL
#  url        | character(255)              | NOT NULL
#  image      | character(255)              | NOT NULL
#  price      | integer                     | NOT NULL
#  created_at | timestamp without time zone |
#  updated_at | timestamp without time zone |
# Indexes:
#  hardwares_pkey       | PRIMARY KEY btree (id)
#  hardwares_code_index | UNIQUE btree (code)

class Hardware < Sequel::Model
  many_to_many :builds

  def validate
    super
    validates_presence [:provider, :code, :name, :url, :image, :price]
    validates_includes %w[mai_hoang ha_noi_computer ha_noi_new tan_doanh phong_vu nam_an], :provider
  end

  dataset_module do
    def recent
      where(id: distinct.select(:id).join(:builds_hardwares, id: :hardware_id).order(Sequel.desc('builds_hardwares.id')).limit(20)
    end
  end
end
