# frozen_string_literal: true

module Providers
  class Tandoanh
    URL = 'http://tandoanh.vn/search'

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
          url = ele.first['href']
          price = html_product.css('.pro-price').first.content.gsub(/[^\d]/, '').to_i
          {
            name: name,
            price: price,
            url: url,
            provider: 'tandoanh'
          }
        end
      end
    end
  end
end
