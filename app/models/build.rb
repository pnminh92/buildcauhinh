# Table: builds
# Columns:
#  id              | integer                     | PRIMARY KEY DEFAULT nextval('builds_id_seq'::regclass)
#  user_id         | integer                     | NOT NULL
#  slug            | character varying(255)      | NOT NULL
#  title           | character varying(255)      | NOT NULL
#  description     | character varying(500)      |
#  total_price     | integer                     | NOT NULL
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
  include Concerns::CursorPagination

  attr_accessor :hardware_ids

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
    errors.add(:hardwares, I18n.t('errors.max_elements', num: hardware_ids)) if hardware_ids&.size.to_i > SETTINGS['part_type'].size
    errors.add(:hardwares, I18n.t('errors.format')) unless hardwares_ids.is_a?(Array)
  end

  def display_date
    created_at.strftime('%d/%m/%Y')
  end

  dataset_module do
    def search(params)
      q = self
      q = q.where(cpu_type: params[:cpu_type]) if params['cpu_type']
      q = case params['price_type']
          when 'under_7'
            where{total_price < 7000000}
          when 'between_7_12'
            where{total_price >= 7000000}.where{total_price <= 12000000}
          when 'between_13_20'
            where{total_price >= 13000000}.where{total_price <= 20000000}
          when 'above_20'
            where{total_price > 20000000}
          else
            q
          end
      q
    end
  end

  def self.total_price(hardwares)
    hardwares.inject(0) { |o, h| o += h.price  }
  end
end
