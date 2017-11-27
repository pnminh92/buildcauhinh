# frozen_string_literal: true

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

  gem 'rubocop', require: false

  gem 'scss_lint'

  gem 'capistrano', '~> 3.6.0'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano3-puma'
  gem 'capistrano-sidekiq'
end

group :development, :test do
  gem 'byebug', platform: %i[mri mingw x64_mingw]
  gem 'awesome_print'
end
