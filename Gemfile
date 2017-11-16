source 'https://rubygems.org'

require 'logger'
require 'json'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'sinatra-flash'

gem 'puma'
gem 'sidekiq'
gem 'rake'

# Internationalize
gem 'i18n'

# File attachment
gem 'shrine'

# postgresql and sequel ORM
gem 'pg'
gem 'sequel'
gem 'sequel_secure_password'
gem 'sequel_pg', require: 'sequel'

# Mailer
gem 'mail'

gem 'http'
gem 'nokogiri'

group :development do
  gem 'shotgun'
  gem 'letter_opener'

  gem 'sequel-annotate'
end

group :development, :test do
  gem 'awesome_print'
  gem 'byebug', platform: [:mri, :mingw, :x64_mingw]
end
