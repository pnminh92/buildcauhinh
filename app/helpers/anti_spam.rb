# frozen_string_literal: true

module Buildcauhinh
  module AntiSpam
    TIMESTAMP_THRESHOLD = 4
    def detect_spam!
      time_to_submit = Time.now - session[:anti_spam_timestamp]
      return unless time_to_submit < TIMESTAMP_THRESHOLD

      logger.warn("Potential spam detected for IP #{env['REMOTE_ADDR']}. Timestamp threshold not reached (took #{time_to_submit.to_i}s).")
      flash[:error] = I18n.t('views.spam_msg')
      redirect to('/')
    end
  end
end
