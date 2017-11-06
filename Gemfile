source 'https://rubygems.org'

require 'logger'
require 'json'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'puma'
gem 'sidekiq'
gem 'rake'

gem 'pg'
gem 'sequel'
gem 'sequel_secure_password'
gem 'sequel_pg', require: 'sequel'

gem 'http'
gem 'nokogiri'

group :development do
  gem 'shotgun'

  gem 'sequel-annotate'
end

group :development, :test do
  gem 'awesome_print'
  gem 'byebug', platform: [:mri, :mingw, :x64_mingw]
end
