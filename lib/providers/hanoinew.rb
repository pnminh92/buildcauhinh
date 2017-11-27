# frozen_string_literal: true

module Providers
  class Hanoinew
    URL = 'http://www.hanoinew.vn/index.php'
    SLUG = 'ha_noi_new'

    class << self
      def search(words)
        body = HTTP.get(URL, params: { route: 'product/search', category_id: 0, search: words }).to_s
        parse(body)
      rescue Timeout::Error
        []
      end

      private

      def parse(html)
        html_doc = Nokogiri::HTML(html)
        html_doc.css('#content > .row .product-layout').map do |html_product|
          ele = html_product.css('.caption h4 a')
          name = ele.first.content
          part = detect_part_type(name)
          next unless part
          code = Util.codify(name, SLUG)
          next if ::Hardware.first(code: code)
          {
            code: code,
            name: name,
            part: part,
            price: html_product.css('.caption .price').first.content.gsub(/[^\d]/, '').to_i,
            url: ele.first['href'],
            image_url: html_product.css('.image img.image1').first['src'],
            provider: SLUG
          }
        end.compact
      end

      def detect_part_type(name)
        case name
        when /\A(?=.*intel|amd)(?=.*cpu)(?=.*\d\.\d+\s?ghz).*\z/i
          'cpu'
        when /\A(?=.*asus|msi|gigabyte|asrock)(?=.*mainboard)(?=.*[a-z]\d{2,4}).*\z/i
          'mainboard'
        when /\A(?=.*adata|apacer|avexir|corsair|geil|kingmax|g\.?skill|kingston)(?=.*ram)(?=.*ddr)(?=.*\d{1,2}gb)(?=.*\d{4}).*\z/i
          'ram'
        when /\A(?=.*asus|colorful|galax|gigabyte|inno3d|msi|zotac|quadro)(?=.*vga).*\z/i
          'vga'
        when /\A(?=.*cooler\smaster|antec|corsair|cougar|orient|raimax|sama|seasonic|segostep|super\sflower|xigmatek)(?=.*nguồn)(?=.*\d{3,4}w?).*\z/i
          'psu'
        when /\A(?=.*adata|corsair|intel|kingmax|kingston|lite-on|plextor|samsung|wd)(?=.*\d{3}gb|\dtb)(?=.*ssd|sata|m\.?2).*\z/i
          'ssd'
        when /\A(?=.*wd|seagate)(?=.*\d{1,2}tb)(?=.*hdd|sata|cache).*\z/i
          'hdd'
        when /\A(?=.*acer|aoc|asus|benq|dell|lg|samsung|viewsonic)(?=.*màn\shình).*\z/i
          'monitor'
        when /\A(?=.*aigo|cooler\smaster|corsair|cougar|deepcool|in\swin|nzxt|orient|phanteks|sama|segostep|vitra|xigmatek)(?=.*case).*\z/i
          'case'
        end
      end
    end
  end
end
