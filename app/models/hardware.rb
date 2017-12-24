# frozen_string_literal: true

# Table: hardwares
# Columns:
#  id                 | integer                     | PRIMARY KEY DEFAULT nextval('hardwares_id_seq'::regclass)
#  part               | part_type                   | NOT NULL
#  provider           | provider_type               | NOT NULL
#  code               | character varying(255)      | NOT NULL
#  name               | character varying(255)      | NOT NULL
#  url                | character varying(255)      | NOT NULL
#  image_url          | character varying(255)      | NOT NULL
#  price              | integer                     | NOT NULL
#  created_at         | timestamp without time zone |
#  updated_at         | timestamp without time zone |
#  cloudinary_id      | character varying(127)      |
#  cloudinary_version | character varying(31)       |
#  cloudinary_format  | character varying(15)       |
# Indexes:
#  hardwares_pkey       | PRIMARY KEY btree (id)
#  hardwares_code_index | UNIQUE btree (code)
# Referenced By:
#  builds_hardwares | builds_hardwares_hardware_id_fkey | (hardware_id) REFERENCES hardwares(id)

module Buildcauhinh
  class Hardware < Sequel::Model
    include Concerns::CursorPagination

    many_to_many :builds

    def validate
      super
      validates_presence %i[provider code name url image_url price]
      validates_presence :part
      validates_includes SETTINGS['hardware_providers'], :provider
      validates_includes SETTINGS['part_type'], :part
    end

    def display_price
      Buildcauhinh::Util.to_vnd(price)
    end

    dataset_module do
      def search(params)
        q = self
        q = q.where(provider: params['providers']) if params['providers']
        q = q.where(part: params['part']) if params['part']
        q = q.grep(:name, params['word'].strip.split(' ').map { |w| "%#{w}%" }, all_patterns: true, case_insensitive: true) if params['word'] && params['word'] != ''
        q
      end

      def fetch_from_providers(params)
        return [] unless params['word'] && params['word'].to_s.strip != ''
        tmp = []
        params['providers'].each { |provider| tmp.concat(Providers.const_get(provider.capitalize.delete('_')).search(params['word'])) }
        import(%i[code name part price url image_url provider], tmp.map(&:values)) unless tmp.empty?
        where_all(code: tmp.map { |o| o[:code] })
      end
    end
  end
end
