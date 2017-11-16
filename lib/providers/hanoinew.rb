# frozen_string_literal: true

module Providers
  class Hanoinew
    URL = 'http://www.hanoinew.vn/index.php'
    SLUG = 'ha_noi_new'

    class << self
      def search(words)
        begin
          body = HTTP.get(URL, params: { route: 'product/search', category_id: 0, search: words }).to_s
          parse(body)
        rescue TimeoutError
          []
        end
      end

      private

      def parse(html)
        html_doc = Nokogiri::HTML(html)
        html_doc.css('#content > .row .product-layout').map do |html_product|
          ele = html_product.css('.caption h4 a')
          name = ele.first.content
          code = ::Util.codify(name, SLUG)
          next if ::Hardware.first(code: code)
          {
            code: code,
            name: name,
            price: html_product.css('.caption .price').first.content.gsub(/[^\d]/, '').to_i,
            url: ele.first['href'],
            image_url: html_product.css('.image img.image1').first['src'],
            provider: SLUG
          }
        end.compact
      end
    end
  end
end
