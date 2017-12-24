# frozen_string_literal: true

source 'https://rubygems.org'

require 'logger'

gem 'erubis'
gem 'http'
gem 'i18n'
gem 'mail'
gem 'nokogiri'
gem 'pg'
gem 'puma'
gem 'rake'
gem 'sequel'
gem 'sequel_pg', require: 'sequel'
gem 'sequel_secure_password'
gem 'shrine'
gem 'shrine-cloudinary'
gem 'sidekiq'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'sinatra-flash'

group :production do
  gem 'logglier'
  gem 'redis-namespace'
end

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
