# Table: builds_hardwares
# Primary Key: (build_id, hardware_id)
# Columns:
#  build_id    | integer                     |
#  hardware_id | integer                     |
#  created_at  | timestamp without time zone |
#  updated_at  | timestamp without time zone |
# Indexes:
#  builds_hardwares_pkey                       | PRIMARY KEY btree (build_id, hardware_id)
#  builds_hardwares_build_id_hardware_id_index | btree (build_id, hardware_id)
# Foreign key constraints:
#  builds_hardwares_build_id_fkey    | (build_id) REFERENCES builds(id)
#  builds_hardwares_hardware_id_fkey | (hardware_id) REFERENCES hardwares(id)

# frozen_string_literal: true

# Table: builds_hardwares
# Primary Key: (build_id, hardware_id)
# Columns:
#  build_id    | integer                     |
#  hardware_id | integer                     |
#  created_at  | timestamp without time zone |
#  updated_at  | timestamp without time zone |
# Indexes:
#  builds_hardwares_pkey                       | PRIMARY KEY btree (build_id, hardware_id)
#  builds_hardwares_build_id_hardware_id_index | btree (build_id, hardware_id)
# Foreign key constraints:
#  builds_hardwares_build_id_fkey    | (build_id) REFERENCES builds(id)
#  builds_hardwares_hardware_id_fkey | (hardware_id) REFERENCES hardwares(id)

class BuildsHardware < Sequel::Model
  many_to_one :build
  many_to_one :hardware

  dataset_module do
    def build(build_id, hardware_ids)
      data = hardware_ids.map { |id| [build_id, id] }
      import(%i[build_id hardware_id], data)
    end
  end
end
