# frozen_string_literal: true

module Buildcauhinh
  module Cloudinary
    def cl_hardware_url(hardware)
      if hardware.cloudinary_id
        "https://res.cloudinary.com/buildcauhinh/image/upload/q_auto:eco/v#{hardware.cloudinary_version}/#{hardware.cloudinary_id}.#{hardware.cloudinary_format}"
      end
    end
  end
end
