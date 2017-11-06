# frozen_string_literal: true

module Providers
  class Phongvu
    URL = 'https://phongvu.vn/tim-kiem'

    class << self
      def search(words)
        begin
          ctx = OpenSSL::SSL::SSLContext.new
          ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
          body = HTTP.headers('cookie': 'etoken=261ffd3ffb49baf22212767fd8523a17; erandom=3071;')
                     .get(URL, params: { q: words }, ssl_context: ctx).to_s
          parse(body)
        rescue TimeoutError
          []
        end
      end

      private

      def parse(html)
        html_doc = Nokogiri::HTML(html)
        html_doc.css('.container .product-warp').map do |html_product|
          name = html_product.css('h3.pdTitle').first.content
          url = html_product.css('a').first['href']
          price = html_product.css('.current-price').first.content.gsub(/[^\d]/, '').to_i
          {
            name: name,
            price: price,
            url: url,
            provider: 'phongvu'
          }
        end
      end
    end
  end
end
