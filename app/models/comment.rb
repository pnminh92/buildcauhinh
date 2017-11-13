# Table: comments
# Columns:
#  id         | integer                     | PRIMARY KEY DEFAULT nextval('comments_id_seq'::regclass)
#  user_id    | integer                     | NOT NULL
#  build_id   | integer                     | NOT NULL
#  content    | character varying(500)      | NOT NULL
#  created_at | timestamp without time zone |
#  updated_at | timestamp without time zone |
# Indexes:
#  comments_pkey           | PRIMARY KEY btree (id)
#  comments_build_id_index | btree (build_id)
#  comments_user_id_index  | btree (user_id)

class Comment < Sequel::Model
  many_to_one :user
  many_to_one :build

  def validate
    super
    validates_presence :content
    validates_min_length 30, :content
    validates_max_length 500, :content
  end
end
