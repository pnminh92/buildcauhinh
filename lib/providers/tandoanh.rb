# frozen_string_literal: true

module Providers
  class Tandoanh
    URL = 'http://tandoanh.vn/search'
    DOMAIN = 'http://tandoanh.vn'
    SLUG = 'tan_doanh'

    class << self
      def search(words)
        body = HTTP.get(URL, params: { type: 'product', q: words }).to_s
        parse(body)
      rescue Timeout::Error
        []
      end

      private

      def parse(html)
        html_doc = Nokogiri::HTML(html)
        html_doc.css('.product-list .pro-loop').map do |html_product|
          ele = html_product.css('h3.pro-name a')
          name = ele.first.content
          part = detect_part_type(name)
          next unless part
          code = Util.codify(name, SLUG)
          next if ::Hardware.first(code: code)
          {
            code: code,
            name: name,
            part: part,
            price:  html_product.css('.pro-price').first.content.gsub(/[^\d]/, '').to_i,
            url: DOMAIN + ele.first['href'],
            image_url: html_product.css('.product-img a img')[1]['src'],
            provider: SLUG
          }
        end.compact
      end

      def detect_part_type(name)
        case name
        when /\A(?=.*intel|amd)(?=.*\d\.\d+\s?ghz).*\z/i
          'cpu'
        when /\A(?=.*asus|msi|asrock|gigabyte|colorful)(?=.*[a-z]\d{2,4}).*\z/i
          'mainboard'
        when /\A(?=.*apacer|avexir|geil|mushkin|g\.?skill|kingston|team|crucial|corsair)(?=.*ddr)(?=.*\d{1,2}gb)(?=.*\d{4}).*\z/i
          'ram'
        when /\A(?=.*asus|colorful|gigabyte|msi|quadro|palit|powercolor)(?=.*gddr)(?=.*\dgb|\d{3}\s?bit).*\z/i
          'vga'
        when /\A(?=.*andyson|antec|cooler\smaster|corsair|cougar|fsp|in-win|seasonic|zalman)(?=.*\d{3,4}w?).*\z/i
          'psu'
        when /\A(?=.*avexir|colorful|corsair|intel\soptane|kingston\suv400|mushkin|plextor|samsung|western\sdigital)(?=.*\d{3}gb|\dtb)(?=.*ssd)(?=.*sata|m\.2).*\z/i
          'ssd'
        when /\A(?=.*western\sdigital\scaviar|seagate\sbarracuda|toshiba)(?=.*\d{1,2}tb)(?=.*sata|cache).*\z/i
          'hdd'
        when /\A(?=.*alienware|aoc|crossover|dell|aoc|lg|benq|samsung|asus)(?=.*[a-z]?[2-3]\d[a-z]?)(?=.*lcd|monitor|ips).*\z/i
          'monitor'
        when /\A(?=.*infinity|aerocool|corsair|id\scooling|cougar|zalman|thor|xigmatek|phanteks|cooler\smaster|deepcool|nzxt|in-win|sama).*\z/i
          'case'
        end
      end
    end
  end
end
