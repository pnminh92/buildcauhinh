# frozen_string_literal: true

module Providers
  class Phongvu
    URL = 'https://phongvu.vn/tim-kiem'
    SLUG = 'phong_vu'

    class << self
      def search(words)
        begin
          ctx = OpenSSL::SSL::SSLContext.new
          ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
          body = HTTP.headers('cookie': 'etoken=25f9b476a9c4150c70c6e78dc949249a; erandom=5237;')
                     .get(URL, params: { q: words }, ssl_context: ctx).to_s
          parse(body)
        rescue Timeout::Error
          []
        end
      end

      private

      def parse(html)
        html_doc = Nokogiri::HTML(html)
        html_doc.css('.container .product-warp').map do |html_product|
          name = html_product.css('h3.pdTitle').first.content
          code = Util.codify(name, SLUG)
          next if ::Hardware.first(code: code)
          {
            code: code,
            name: name,
            price: html_product.css('.current-price').first.content.gsub(/[^\d]/, '').to_i,
            url: html_product.css('a').first['href'],
            image_url: html_product.css('.pdImg img').first['src'],
            provider: SLUG
          }
        end.compact
      end
    end
  end
end
