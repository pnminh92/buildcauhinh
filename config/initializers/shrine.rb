# frozen_string_literal: true

require 'shrine/storage/file_system'
require 'shrine/storage/cloudinary'

Cloudinary.config(
  cloud_name: 'buildcauhinh',
  api_key: '181265141548511',
  api_secret: 'lCDYnUOwvzXUFGohkk_2E1uLVMo',
  secure: true
)

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
  store: Shrine::Storage::Cloudinary.new
}

Shrine.plugin :sequel # or :activerecord
Shrine.plugin :cached_attachment_data # for forms
Shrine.plugin :rack_file # for non-Rails apps
