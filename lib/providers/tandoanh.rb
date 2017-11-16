# frozen_string_literal: true

module Providers
  class Tandoanh
    URL = 'http://tandoanh.vn/search'
    DOMAIN = 'http://tandoanh.vn'
    SLUG = 'tan_doanh'

    class << self
      def search(words)
        begin
          body = HTTP.get(URL, params: { type: 'product', q: words }).to_s
          parse(body)
        rescue TimeoutError
          []
        end
      end

      private

      def parse(html)
        html_doc = Nokogiri::HTML(html)
        html_doc.css('.product-list .pro-loop').map do |html_product|
          ele = html_product.css('h3.pro-name a')
          name = ele.first.content
          code = ::Util.codify(name, SLUG)
          next if ::Hardware.first(code: code)
          {
            code: code,
            name: name,
            price:  html_product.css('.pro-price').first.content.gsub(/[^\d]/, '').to_i,
            url: DOMAIN + ele.first['href'],
            image_url: html_product.css('.product-img img')[1]['src'],
            provider: SLUG
          }
        end.compact
      end
    end
  end
end
