# Table: builds
# Columns:
#  id              | integer                     | PRIMARY KEY DEFAULT nextval('builds_id_seq'::regclass)
#  user_id         | integer                     | NOT NULL
#  slug            | character varying(255)      | NOT NULL
#  title           | character varying(255)      | NOT NULL
#  description     | character varying(500)      |
#  price_type      | price_type                  | NOT NULL
#  cpu_type        | cpu_type                    | NOT NULL
#  price_showed    | boolean                     | NOT NULL DEFAULT true
#  provider_showed | boolean                     | NOT NULL DEFAULT false
#  created_at      | timestamp without time zone |
#  updated_at      | timestamp without time zone |
# Indexes:
#  builds_pkey       | PRIMARY KEY btree (id)
#  builds_slug_index | UNIQUE btree (slug)
# Foreign key constraints:
#  builds_user_id_fkey | (user_id) REFERENCES users(id)
# Referenced By:
#  comments         | comments_build_id_fkey         | (build_id) REFERENCES builds(id)
#  builds_hardwares | builds_hardwares_build_id_fkey | (build_id) REFERENCES builds(id)

class Build < Sequel::Model
  one_to_many :comments
  many_to_one :user
  many_to_many :hardwares

  add_association_dependencies comments: :delete, hardwares: :nullify

  def before_create
    num = 0
    self.slug = loop do
                  tmp = ::Util.slugify(title, num)
                  num += 1
                  break tmp unless Build.first(slug: tmp)
                end
    super
  end

  def validate
    super
    validates_presence %i[title price_type cpu_type]
    validates_min_length 30, :title
    validates_max_length 255, :title
    validates_includes SETTINGS['cpu_type'], :cpu_type
    validates_includes SETTINGS['price_type'], :price_type
  end

  def display_date
    created_at.strftime('%d/%m/%Y')
  end

  dataset_module do
    def search(params)
      q = self
      q = q.where(price_type: params[:price_type]) if params['price_type']
      q = q.where(cpu_type: params[:cpu_type]) if params['cpu_type']
      q
    end
  end
end
