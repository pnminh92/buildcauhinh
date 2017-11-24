# frozen_string_literal: true

module Providers
  class Maihoang
    URL = 'http://maihoang.com.vn/search'
    SLUG = 'mai_hoang'

    class << self
      def search(words)
        begin
          body = HTTP.get(URL, params: { cat: 0, key: words }).to_s
          parse(body)
        rescue Timeout::Error
          []
        end
      end

      private

      def parse(html)
        html_doc = Nokogiri::HTML(html)
        html_doc.css('.wrapper-pro .pro-item').map do |html_product|
          ele = html_product.css('h2 a')
          name = ele.first.content
          part = detect_part_type(name)
          next unless part
          code = Util.codify(name, SLUG)
          next if ::Hardware.first(code: code)
          {
            code: code,
            name: name,
            part: part,
            price: html_product.css('.pro-price').first.content.gsub(/[^\d]/, '').to_i,
            url: ele.first['href'],
            image_url: html_product.css('.pro-img img').first['data-original'],
            provider: SLUG
          }
        end.compact
      end

      def detect_part_type(name)
        case name
        when /\A(?=.*intel|amd)(?=.*\d\.\d+\s?ghz).*\z/i
          'cpu'
        when /\A(?=.*asus|msi)(?=.*[a-z]\d{2,4}).*\z/i
          'mainboard'
        when /\A(?=.*g\.?skill|kingston)(?=.*ddr)(?=.*\d{1,2}gb)(?=.*\d{4}).*\z/i
          'ram'
        when /\A(?=.*msi|asus|quadro)(?=.*\dg)(?=.*gtx|rx|gt).*\z/i
          'vga'
        when /\A(?=.*seasonic|xigmatek|huntkey|coolerplus|orient)(?=.*\d{3,4}w?).*\z/i
          'psu'
        when /\A(?=.*plextor|kingston|samsung|intel|lite-on)(?=.*\d{3}gb|\dtb)(?=.*ssd|sata|m\.?2).*\z/i
          'ssd'
        when /\A(?=.*wd|seagate)(?=.*\d{1,2}tb)(?=.*sata|cache).*\z/i
          'hdd'
        when /\A(?=.*dell|lg|hp|samsung|benq|asus|viewsonic|philips)(?=.*[a-z]?[2-3]\d[a-z]?)(?=.*lcd|monitor|ips|led).*\z/i
          'monitor'
        when /\A(?=.*xigmatek|cooler\smaster|nzxt|orient|golden\s?field|case|in-win|corsair|sama|aigo).*\z/i
          'case'
        end
      end
    end
  end
end
