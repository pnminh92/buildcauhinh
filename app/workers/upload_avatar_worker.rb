# frozen_string_literal: true

class UploadAvatarWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default

  def perform(data)
    Shrine.plugin :backgrounding
    Shrine::Attacher.promote(data)
  end
end
