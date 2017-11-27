# frozen_string_literal: true

require 'rubygems'
require 'bundler'
Bundler.require(:default, ENV.fetch('RACK_ENV') { 'development' }.to_sym)

require_relative 'app'
