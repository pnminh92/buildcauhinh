# frozen_string_literal: true

module Providers
  class Naman
    URL = 'http://vitinhnaman.com/search'
    SLUG = 'nam_an'

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
        html_doc.css('.product-list .product-item').map do |html_product|
          ele = html_product.css('h3 a')
          name = ele.first.content
          code = ::Util.codify(name, SLUG)
          next if ::Hardware.first(code: code)
          {
            code: code,
            name: name,
            price: html_product.css('.product-price').first.content.gsub(/[^\d]/, '').to_i,
            url: ele.first['href'],
            image_url: html_product.css('.product-img img').first['src'],
            provider: SLUG
          }
        end.compact
      end
    end
  end
end
