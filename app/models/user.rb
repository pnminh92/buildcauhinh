# frozen_string_literal: true

# Table: users
# Columns:
#  id                      | integer                     | PRIMARY KEY DEFAULT nextval('users_id_seq'::regclass)
#  username                | character varying(32)       | NOT NULL
#  password_digest         | character varying(255)      | NOT NULL
#  email                   | character varying(64)       |
#  about                   | character varying(500)      |
#  avatar_data             | text                        |
#  reset_pwd_token         | character varying(255)      |
#  reset_pwd_token_sent_at | timestamp without time zone |
#  created_at              | timestamp without time zone |
#  updated_at              | timestamp without time zone |
# Indexes:
#  users_pkey         | PRIMARY KEY btree (id)
#  users_username_key | UNIQUE btree (username)
# Referenced By:
#  builds   | builds_user_id_fkey   | (user_id) REFERENCES users(id)
#  comments | comments_user_id_fkey | (user_id) REFERENCES users(id)

class User < Sequel::Model
  plugin :secure_password, include_validations: false

  RESET_PWD_TOKEN_EXPIRE = 3600
  REGEX_VALID_USERNAME = /\A[a-z][a-z0-9_\-\.]{2,31}\z/i
  REGEX_VALID_EMAIL = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  one_to_many :comments
  one_to_many :builds

  include AvatarUploader::Attachment.new(:avatar)

  def before_create
    self.avatar = File.open(File.join(App.settings.root, 'app', 'assets', 'default_avatar.png').to_s) unless avatar_data
    super
  end

  def validate
    super
    validates_presence :username
    if modified?
      validates_presence :password, allow_nil: true
      validates_min_length 6, :password, allow_nil: true
    else
      validates_presence :password
      validates_min_length 6, :password
    end
    validates_unique :username
    validates_unique :email, allow_blank: true
    validates_max_length 64, :email
    validates_max_length 500, :about
    validates_format REGEX_VALID_USERNAME, :username
    validates_format REGEX_VALID_EMAIL, :email, allow_blank: true
  end

  def eco_img_url
    avatar_url(quality: 'auto:eco')
  end

  def gen_reset_pwd_token
    token_retries = 0
    self.reset_pwd_token = loop do
      token_retries += 1
      token = SecureRandom.hex(15)
      raise 'Exhauted retries' if token_retries > 5
      break token unless User.where(reset_pwd_token: token).first
    end
    self.reset_pwd_token_sent_at = Time.now
    save_changes
  end

  def reset_pwd_token_valid?
    (Time.now - reset_pwd_token_sent_at) <= RESET_PWD_TOKEN_EXPIRE
  end
end
