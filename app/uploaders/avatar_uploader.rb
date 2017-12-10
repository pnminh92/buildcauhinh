# frozen_string_literal: true

class AvatarUploader < Shrine
  plugin :backgrounding
  plugin :determine_mime_type
  plugin :validation_helpers
  plugin :upload_options, store: ->(_o, _context) do
    {
      folder: 'avatars'
    }
  end

  Attacher.promote { |data| UploadAvatarWorker.perform_async(data) }
  Attacher.delete { |data| DeleteAvatarWorker.perform_async(data) }

  Attacher.validate do
    validate_max_size 2 * 1024 * 1024
    validate_extension_inclusion %w[jpg jpeg png]
    validate_mime_type_inclusion %w[image/jpeg image/png]
  end
end
