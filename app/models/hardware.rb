# Table: hardwares
# Columns:
#  id         | integer                     | PRIMARY KEY DEFAULT nextval('hardwares_id_seq'::regclass)
#  part       | part_type                   | NOT NULL
#  provider   | provider_type               | NOT NULL
#  code       | character varying(255)      | NOT NULL
#  name       | character varying(255)      | NOT NULL
#  url        | character varying(255)      | NOT NULL
#  image_url  | character varying(255)      | NOT NULL
#  price      | integer                     | NOT NULL
#  created_at | timestamp without time zone |
#  updated_at | timestamp without time zone |
# Indexes:
#  hardwares_pkey       | PRIMARY KEY btree (id)
#  hardwares_code_index | UNIQUE btree (code)
# Referenced By:
#  builds_hardwares | builds_hardwares_hardware_id_fkey | (hardware_id) REFERENCES hardwares(id)

class Hardware < Sequel::Model
  include Concerns::CursorPagination

  many_to_many :builds

  def validate
    super
    validates_presence [:part, :provider, :code, :name, :url, :image_url, :price]
    validates_includes Settings['hardware_providers'], :provider
    validates_includes Settings['part_type'], :part
  end

  def display_price
    to_vnd(price) + I18n.t('views.currency')
  end

  private

  def to_vnd(price)
    price = price.to_s.split('').reverse
    tmp = price.each_with_index.inject('') { |o, (v, k)| o = (k % 3 == 2) ? '.' + v + o : v + o }
    tmp[0] == '.' ? tmp[1..-1] : tmp
  end
end
