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
        rescue Timeout::Error
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
          part = detect_part_type(name)
          next unless part
          code = Util.codify(name, SLUG)
          next if ::Hardware.first(code: code)
          discount = (html_product.css('.price_off').first&.content&.gsub(/[^\d]/, '').to_f / 100) * price
          {
            code: code,
            name: name,
            part: part,
            price: price - discount,
            url: DOMAIN + ele.first['href'],
            image_url: DOMAIN + html_product.css('.p_img img').first['src'],
            provider: SLUG
          }
        end.compact
      end

      def detect_part_type(name)
        case name
        when /\A(?=.*intel|amd)(?=.*cpu)(?=.*\d\.\d+\s?ghz).*\z/i
          'cpu'
        when /\A(?=.*asrock|asus|biostar|colorful|foxconn|gigabyte|intel|maxsun|msi)(?=.*mainboard)(?=.*[a-z]\d{2,4}).*\z/i
          'mainboard'
        when /\A(?=.*adata|avexir|axpro|corsair|crucial|gskill|hynix|ibm|kingmax|kingston|samsung|silicon\spower|team|transcend)(?=.*ram)(?=.*ddr)(?=.*\d{1,2}gb)(?=.*\d{4}).*\z/i
          'ram'
        when /\A(?=.*asus|colorful|galax|gigabyte|inno3d|his|msi|palit|quadro|zotac|powercolor|fire\spro)(?=.*vga).*\z/i
          'vga'
        when /\A(?=.*acbel|andyson|antec|cooler\smaster|corsair|deepcool|fsp|golden\sfield|huntkey|in\swin|raidmax|orient|saga|sama|seasonic|segostep|xigmatek|super\sflower|thermaltake)(?=.*\d{3,4}w?).*\z/i
          'psu'
        when /\A(?=.*adata|avexir|colorful|corsair|crucial|intel|kingston|plextor|samsung|silicon\spower|team|toshiba|transcend|wd)(?=.*\d{3}gb|\dtb)(?=.*ssd|sata|m\.?2).*\z/i
          'ssd'
        when /\A(?=.*wd|western|seagate|toshiba)(?=.*\d{1,2}tb)(?=.*hdd|sata|cache).*\z/i
          'hdd'
        when /\A(?=.*acer|aoc|asus|benq|crossover|dell|hp|lg|newmen|philip|samsung|viewsonic|viewparker)(?=.*màn\shình).*\z/i
          'monitor'
        when /\A(?=.*aerocool|antec|cooler\smaster|corsair|cougar|deepcool|differ|gamemax|golden\sfield|in\swin|infinity|jonsbo|nzxt|orient|phanteks|raidmax|sama|segostep|thermaltake|vitra|xigmatek|zidli)(?=.*case).*\z/i
          'case'
        end
      end
    end
  end
end
