# frozen_string_literal: true

class DeleteAvatarWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default

  def perform(data)
    Shrine.plugin :backgrounding
    Shrine::Attacher.delete(data)
  end
end
