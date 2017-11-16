# frozen_string_literal: true

module Providers
  class Hanoicomputer
    DOMAIN = 'https://www.hanoicomputer.vn'
    URL = 'https://www.hanoicomputer.vn/tim'
    SLUG = 'ha_noi_computer'

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
          code = ::Util.codify(name, SLUG)
          next if ::Hardware.first(code: code)
          discount = (html_product.css('.price_off').first&.content&.gsub(/[^\d]/, '').to_f / 100) * price
          {
            code: code,
            name: name,
            price: price - discount,
            url: DOMAIN + ele.first['href'],
            image_url: DOMAIN + html_product.css('.p_img img').first['src'],
            provider: SLUG
          }
        end.compact
      end
    end
  end
end
