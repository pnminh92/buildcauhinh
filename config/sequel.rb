# Sequel open connection to database
DB = Sequel.connect(YAML.load_file(File.join(settings.root, 'config', 'database.yml').to_s)[ENV.fetch('RACK_ENV') { 'development' }])
DB.extension :pagination

# Sequel load plugins
Sequel::Model.raise_on_save_failure = false
Sequel::Model.plugin :association_dependencies
Sequel::Model.plugin :json_serializer
Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :dataset_associations

# Sequel overrides
class Sequel::Model
  private

  def default_validation_helpers_options(type)
    case type
    when :exact_length
      { message: ->(exact) { I18n.t('errors.exact', exact: exact) } }
    when :format
      { message: ->(with) { I18n.t('errors.format') } }
    when :includes
      { message: ->(set) { I18n.t('errors.includes', includes: set.inspect) } }
    when :integer
      { message: -> { I18n.t('errors.integer') } }
    when :length_range
      { message: ->(range) { I18n.t('errors.length_range') } }
    when :max_length
      { message: ->(max) { I18n.t('errors.max_length', max: max) } }
    when :nil_message
      { message: -> { I18n.t('errors.nil_message') } }
    when :min_length
      {message: ->(min) { I18n.t('errors.min_length', min: min) } }
    when :not_null
      { message: -> { I18n.t('errors.not_null') } }
    when :numeric
      { message: -> { I18n.t('errors.numeric') } }
    when :operator
      { message: ->(operator, rhs) { I18n.t('errors.operator', operator: operator, rhs: rhs) } }
    when :type
      { message: ->(klass) {
        klass.is_a?(Array) ? I18n.t('errors.type.array', array: klass.join(' or ').downcase) : I18n.t('errors.type.single', single: klass.to_s.downcase)
      } }
    when :presence
      { message: -> { I18n.t('errors.presence') } }
    when :unique
      { message: -> { I18n.t('errors.unique') } }
    else
      super
    end
  end
end

class Sequel::Model::Errors
  def full_messages_for(model, attr)
    inject([]) do |m, kv|
      att, errors = *kv
      next m unless att == attr
      att.is_a?(Array) ? Array(att).map!{|v| I18n.t("attributes.#{model}.#{v}")} : att = I18n.t("attributes.#{model}.#{att}")
      errors.each {|e| m << (e.is_a?(::Sequel::LiteralString) ? e : "#{Array(att).join(I18n.t('errors.joiner'))} #{e}")}
      m
    end
  end
end
