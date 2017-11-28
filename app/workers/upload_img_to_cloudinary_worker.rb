# frozen_string_literal: true

class UploadImgToCloudinaryWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default

  def perform(images_url); end
end
