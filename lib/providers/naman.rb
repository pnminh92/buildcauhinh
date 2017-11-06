# frozen_string_literal: true

module Providers
  class Naman
    URL = 'http://vitinhnaman.com/search'

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
          url = ele.first['href']
          price = html_product.css('.product-price').first.content.gsub(/[^\d]/, '').to_i
          {
            name: name,
            price: price,
            url: url,
            provider: 'naman'
          }
        end
      end
    end
  end
end
