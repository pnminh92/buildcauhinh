# frozen_string_literal: true

module Providers
  class Hanoicomputer
    URL = 'https://www.hanoicomputer.vn/tim'

    class << self
      def search(words)
        begin
          body = HTTP.timeout(write: 2, connect: 4, read: 8).get(URL, params: { scat_id: 0, q: words }).to_s
          parse(body)
        rescue TimeoutError
          []
        end
      end

      private

      def parse(html)
        html_doc = Nokogiri::HTML(html)
        html_doc.css('.product_list li').map do |html_product|
          price = html_product.css('.p_old_price').first&.content&.gsub(/[^\d]/, '').to_i
          next unless price > 0
          ele = html_product.css('.p_name')
          name = ele.first.content
          url = ele.first['href']
          discount = (html_product.css('.price_off').first&.content&.gsub(/[^\d]/, '').to_f / 100) * price
          {
            name: name,
            price: price - discount,
            url: url,
            provider: 'hanoicomputer'
          }
        end.compact
      end
    end
  end
end
