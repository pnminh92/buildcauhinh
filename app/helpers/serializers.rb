module BuildCasePc
  module Serializers
    def hardware_serializer(hardwares)
      hardwares.map do |hardware|
        {
          id: hardware.id,
          name: hardware.name,
          url: hardware.url,
          image_url: hardware.image_url,
          provider: I18n.t("views.#{hardware.provider}"),
          display_price: hardware.display_price
        }
      end
    end

    def build_serializer(builds)
      builds.map do |build|
        {
          id: build.id,
          title: build.title,
          slug: build.slug,
          price_type: I18n.t("views.#{build.price_type}"),
          cpu_type: I18n.t("views.#{build.cpu_type}"),
          display_date: build.display_date,
          user: {
            username: build.user.username,
            short_username: build.user.short_username,
            avatar_url: build.user.avatar_url
          }
        }
      end
    end
  end
end
