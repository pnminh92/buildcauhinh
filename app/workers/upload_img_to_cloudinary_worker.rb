# frozen_string_literal: true

class UploadImgToCloudinaryWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default

  def perform(hardware_ids)
    hardwares = Hardware.where_all(id: hardware_ids)
    hardwares.each do |hardware|
      next unless hardware.image_url
      res = Cloudinary::Uploader.upload(hardware.image_url, folder: 'hardwares/', allowed_formats: ['jpg', 'jpeg', 'png'])
      hardware.update(cloudinary_id: res['public_id'], cloudinary_version: res['version'], cloudinary_format: res['format'])
    end
  end
end
