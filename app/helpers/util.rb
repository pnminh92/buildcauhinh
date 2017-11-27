# frozen_string_literal: true

module BuildCasePc
  module Util
    def username(u)
      "@#{u}"
    end

    def model_text_error(errors, model, attr)
      "<p class=\"model-text-error\">#{errors.full_messages_for(model, attr).first}</p>" if errors && errors[attr]
    end

    def single_text_error(message = nil)
      "<p class=\"single-text-error\">#{message}</p>" if message
    end

    def providers
      SETTINGS['hardware_providers'].map { |p| { value: p, text: I18n.t("views.#{p}") } }
    end

    def self.to_vnd(price)
      price = price.to_s.split('').reverse
      tmp = price.each_with_index.inject('') { |o, (v, k)| k % 3 == 2 ? '.' + v + o : v + o } + I18n.t('views.currency')
      tmp[0] == '.' ? tmp[1..-1] : tmp
    end
  end
end
