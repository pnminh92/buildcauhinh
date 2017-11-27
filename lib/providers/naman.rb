# frozen_string_literal: true

module Providers
  class Naman
    URL = 'http://vitinhnaman.com/search'
    SLUG = 'nam_an'

    class << self
      def search(words)
        body = HTTP.get(URL, params: { cat: 0, key: words }).to_s
        parse(body)
      rescue Timeout::Error
        []
      end

      private

      def parse(html)
        html_doc = Nokogiri::HTML(html)
        html_doc.css('.product-list .product-item').map do |html_product|
          ele = html_product.css('h3 a')
          name = ele.first.content
          part = detect_part_type(name)
          next unless part
          code = Util.codify(name, SLUG)
          next if ::Hardware.first(code: code)
          {
            code: code,
            name: name,
            part: part,
            price: html_product.css('.product-price').first.content.gsub(/[^\d]/, '').to_i,
            url: ele.first['href'],
            image_url: html_product.css('.product-img img').first['src'],
            provider: SLUG
          }
        end.compact
      end

      def detect_part_type(name)
        case name
        when /\A(?=.*intel|amd)(?=.*\d\.\d+\s?ghz).*\z/i
          'cpu'
        when /\A(?=.*asus|msi|asrock|gigabyte)(?=.*[a-z]\d{2,4}).*\z/i
          'mainboard'
        when /\A(?=.*g\.?skill|kingston|team|adata|corsair)(?=.*ddr)(?=.*\d{1,2}gb)(?=.*\d{4}).*\z/i
          'ram'
        when /\A(?=.*msi|asus|powercolor|quadro|gigabyte|colorful|palit|inno3d|his|galax)(?=.*gddr)(?=.*\dgb|\d{3}\s?bit).*\z/i
          'vga'
        when /\A(?=.*fsp|xigmatek|corsair|seasonic|rosewill|super\sflower)(?=.*\d{3,4}).*\z/i
          'psu'
        when /\A(?=.*plextor|wd|adata|samsung)(?=.*\d{3}gb|\dtb)(?=.*ssd)(?=.*sata).*\z/i
          'ssd'
        when /\A(?=.*wd)(?=.*\dtb)(?=.*cache)(?=.*sata).*\z/i
          'hdd'
        when /\A(?=.*dell|aoc|lg|benq|viewsonic|samsung|acer|asus)(?=.*[2-3]\d).*\z/i
          'monitor'
        when /\A(?=.*vitra|jonsbo|xigmatek|nzxt|in-win|infinity|corsair|sama|gigabyte|phanteks|deep\scool|segostep|sama|aerocool|aigo|knight|case).*\z/i
          'case'
        end
      end
    end
  end
end
