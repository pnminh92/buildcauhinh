# Table: builds
# Columns:
#  id              | integer                     | PRIMARY KEY DEFAULT nextval('builds_id_seq'::regclass)
#  user_id         | integer                     | NOT NULL
#  slug            | character varying(255)      | NOT NULL
#  title           | character varying(255)      | NOT NULL
#  price_type      | price_type                  | NOT NULL
#  cpu_type        | cpu_type                    | NOT NULL
#  price_showed    | boolean                     | NOT NULL DEFAULT true
#  provider_showed | boolean                     | NOT NULL DEFAULT false
#  created_at      | timestamp without time zone |
#  updated_at      | timestamp without time zone |
# Indexes:
#  builds_pkey          | PRIMARY KEY btree (id)
#  builds_slug_index    | UNIQUE btree (slug)
#  builds_user_id_index | btree (user_id)

class Build < Sequel::Model
  one_to_many :comments
  many_to_one :user
  many_to_many :hardwares

  def validate
    super
    validates_presence :price_type
    validates_presence :cpu_type
    validates_presence :price_showed
    validates_presence :provider_showed
    validates_includes SETTINGS['cpu_type'], :cpu_type
    validates_includes SETTINGS['price_type'], :price_type
  end
end
