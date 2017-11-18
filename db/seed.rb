require_relative '../boot'

User.create(username: '@minh', password: 'gamegame', email: 'pnminh2004@gmail.com')

Build.import([:user_id, :slug, :title, :total_price, :cpu_type, :price_showed, :provider_showed, :created_at, :updated_at], [
  [1, 'cau-hinh-intel-7tr-giai-tri-nhe-nhang', 'Cấu hình Intel 7tr giải trí nhẹ nhàng', 12000000, 'intel', true, false, Time.now, Time.now],
  [1, 'tu-van-dan-may-intel-phong-net', 'Tư vấn dàn máy Intel phòng net', 7000000, 'intel', true, false, Time.now, Time.now],
  [1, 'dan-may-intel-chien-game', 'Dàn máy intel chiến game', 14000000, 'intel', true, false, Time.now, Time.now],
  [1, 'cau-hinh-intel-7tr-giai-tri-nhe-nhang-1', 'Cấu hình Intel 7tr giải trí nhẹ nhàng', 21000000, 'intel', true, false, Time.now, Time.now],
  [1, 'cau-hinh-intel-7tr-giai-tri-nhe-nhang-2', 'Cấu hình Intel 7tr giải trí nhẹ nhàng', 6000000, 'intel', true, false, Time.now, Time.now]
])

Comment.import([:user_id, :build_id, :content, :created_at, :updated_at], [
  [1, 1, 'Thím build như này chuẩn vl', Time.now, Time.now],
  [1, 2, 'Thím build như này chuẩn vl', Time.now, Time.now],
  [1, 3, 'Thím build như này chuẩn vl', Time.now, Time.now],
  [1, 4, 'Thím build như này chuẩn vl', Time.now, Time.now],
  [1, 5, 'Thím build như này chuẩn vl', Time.now, Time.now],
  [1, 1, 'Thím build như này chuẩn vl', Time.now, Time.now],
  [1, 2, 'Thím build như này chuẩn vl', Time.now, Time.now],
  [1, 3, 'Thím build như này chuẩn vl', Time.now, Time.now],
  [1, 4, 'Thím build như này chuẩn vl', Time.now, Time.now],
  [1, 5, 'Thím build như này chuẩn vl', Time.now, Time.now],
  [1, 1, 'Thím build như này chuẩn vl', Time.now, Time.now],
  [1, 2, 'Thím build như này chuẩn vl', Time.now, Time.now],
  [1, 3, 'Thím build như này chuẩn vl', Time.now, Time.now],
  [1, 4, 'Thím build như này chuẩn vl', Time.now, Time.now],
  [1, 5, 'Thím build như này chuẩn vl', Time.now, Time.now]
])
