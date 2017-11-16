module Timgialinhkien
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
  end
end
