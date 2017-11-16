# frozen_string_literal: true

module Providers
  class Maihoang
    URL = 'http://maihoang.com.vn/search'
    SLUG = 'mai_hoang'

    class << self
      def search(words)
        begin
          body = HTTP.get(URL, params: { cat: 0, key: words }).to_s
          parse(body)
        rescue TimeoutError
          []
        end
      end

      private

      def parse(html)
        html_doc = Nokogiri::HTML(html)
        html_doc.css('.wrapper-pro .pro-item').map do |html_product|
          ele = html_product.css('h2 a')
          name = ele.first.content
          code = ::Util.codify(name, SLUG)
          next if ::Hardware.first(code: code)
          {
            code: code,
            name: name,
            price: html_product.css('.pro-price').first.content.gsub(/[^\d]/, '').to_i,
            url: ele.first['href'],
            image_url: html_product.css('.pro-img img').first['data-original'],
            provider: SLUG
          }
        end.compact
      end
    end
  end
end
