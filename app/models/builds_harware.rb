# Table: builds_hardwares
# Columns:
#  id          | integer                     | PRIMARY KEY DEFAULT nextval('builds_hardwares_id_seq'::regclass)
#  build_id    | integer                     | NOT NULL
#  hardware_id | integer                     | NOT NULL
#  created_at  | timestamp without time zone |
#  updated_at  | timestamp without time zone |
# Indexes:
#  builds_hardwares_pkey                       | PRIMARY KEY btree (id)
#  builds_hardwares_build_id_hardware_id_index | UNIQUE btree (build_id, hardware_id)

class BuildsHardware < Sequel::Model
  many_to_one :build
  many_to_one :hardware
end
