# Table: users
# Columns:
#  id              | integer                     | PRIMARY KEY DEFAULT nextval('users_id_seq'::regclass)
#  username        | character varying(32)       | NOT NULL
#  email           | character varying(64)       | NOT NULL
#  password_digest | character(255)              | NOT NULL
#  avatar_url      | character varying(500)      | NOT NULL
#  created_at      | timestamp without time zone |
#  updated_at      | timestamp without time zone |
# Indexes:
#  users_pkey         | PRIMARY KEY btree (id)
#  users_email_key    | UNIQUE btree (email)
#  users_username_key | UNIQUE btree (username)

class User < Sequel::Model
  plugin :secure_password, include_validations: false

  REGEX_VALID_USERNAME = /\A[a-z0-9]{1}[a-z0-9_\-\.]{1,30}[a-z0-9]{1}\z/i
  REGEX_VALID_EMAIL = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  one_to_many :comments
  one_to_many :builds

  def validate
    super
    validates_presence %i[username email password]
    validates_unique %i[username email]
    validates_min_length 6, :password
    validates_max_length 64, :email
    validates_format REGEX_VALID_USERNAME, :username
    validates_format REGEX_VALID_EMAIL, :email
  end
end
