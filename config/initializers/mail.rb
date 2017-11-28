# frozen_string_literal: true

Mail.defaults do
  case App.settings.environment
  when :development
    delivery_method LetterOpener::DeliveryMethod, location: File.join(App.settings.root, 'tmp', 'letter_opener')
  when :test
    delivery_method :test
  when :production
    delivery_method :smtp, {
      address:              ENV['BUILDCAUHINH_MAILGUN_HOST'],
      port:                 587,
      user_name:            ENV['BUILDCAUHINH_MAILGUN_USERNAME'],
      password:             ENV['BUILDCAUHINH_MAILGUN_PASSWORD'],
      authentication:       'plain',
      enable_starttls_auto: true
    }
  end
end
