# frozen_string_literal: true

Mail.defaults do
  case App.settings.environment
  when :development
    delivery_method LetterOpener::DeliveryMethod, location: File.join(App.settings.root, 'tmp', 'letter_opener')
  when :test
    delivery_method :test
  when :production
    delivery_method :smtp
  end
end
