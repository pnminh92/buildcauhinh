# frozen_string_literal: true

module Providers
  class Hanoinew
    URL = 'http://www.hanoinew.vn/index.php'

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
          url = ele.first['href']
          price = html_product.css('.caption .price').first.content.gsub(/[^\d]/, '').to_i
          {
            name: name,
            price: price,
            url: url,
            provider: 'hanoinew'
          }
        end
      end
    end
  end
end
