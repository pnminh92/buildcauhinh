# frozen_string_literal: true

module Providers
  module Util
    def self.vi_to_latin(str)
      str.gsub!(/(à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ)/, 'a')
      str.gsub!(/(è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ)/, 'e')
      str.gsub!(/(ì|í|ị|ỉ|ĩ)/, 'i')
      str.gsub!(/(ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ)/, 'o')
      str.gsub!(/(ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ)/, 'u')
      str.gsub!(/(ỳ|ý|ỵ|ỷ|ỹ)/, 'y')
      str.gsub!(/(đ)/, 'd')

      str.gsub!(/(À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ)/, 'A')
      str.gsub!(/(È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ)/, 'E')
      str.gsub!(/(Ì|Í|Ị|Ỉ|Ĩ)/, 'I')
      str.gsub!(/(Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ)/, 'O')
      str.gsub!(/(Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ)/, 'U')
      str.gsub!(/(Ỳ|Ý|Ỵ|Ỷ|Ỹ)/, 'Y')
      str.gsub!(/(Đ)/, 'D')
      str
    end

    def self.codify(str, prefix)
      "#{prefix}_#{vi_to_latin(str.strip.gsub(/\s/, '_').downcase)}"
    end

    def self.slugify(str, num)
      pattern = vi_to_latin(str.strip.gsub(/\s/, '-')).downcase
      num.positive? ? "#{pattern}-#{num}" : pattern
    end
  end
end
