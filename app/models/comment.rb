# Table: comments
# Columns:
#  id         | integer                     | PRIMARY KEY DEFAULT nextval('comments_id_seq'::regclass)
#  user_id    | integer                     | NOT NULL
#  build_id   | integer                     | NOT NULL
#  content    | character varying(500)      | NOT NULL
#  created_at | timestamp without time zone |
#  updated_at | timestamp without time zone |
# Indexes:
#  comments_pkey | PRIMARY KEY btree (id)
# Foreign key constraints:
#  comments_build_id_fkey | (build_id) REFERENCES builds(id)
#  comments_user_id_fkey  | (user_id) REFERENCES users(id)

# frozen_string_literal: true

# Table: comments
# Columns:
#  id         | integer                     | PRIMARY KEY DEFAULT nextval('comments_id_seq'::regclass)
#  user_id    | integer                     | NOT NULL
#  build_id   | integer                     | NOT NULL
#  content    | character varying(500)      | NOT NULL
#  created_at | timestamp without time zone |
#  updated_at | timestamp without time zone |
# Indexes:
#  comments_pkey | PRIMARY KEY btree (id)
# Foreign key constraints:
#  comments_build_id_fkey | (build_id) REFERENCES builds(id)
#  comments_user_id_fkey  | (user_id) REFERENCES users(id)

class Comment < Sequel::Model
  many_to_one :user
  many_to_one :build

  def validate
    super
    validates_presence :content
    validates_min_length 10, :content
    validates_max_length 500, :content
  end

  def display_date
    time_gap = Time.now - created_at
    min = (time_gap / 60.0).ceil
    hour = (time_gap / 3600.0).ceil
    day = (time_gap / 3600 * 60.0).ceil
    return I18n.t('views.comment_date_min',  min: min) if min < 60
    return I18n.t('views.comment_date_hour', hour: hour) if hour < 24
    I18n.t('views.comment_date_day', day: day)
  end
end
