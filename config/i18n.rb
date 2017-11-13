I18n.load_path = Dir[File.join(settings.root, 'config', 'locales', '*.yml')]
I18n.available_locales = %i[vi en]
I18n.default_locale = :vi
