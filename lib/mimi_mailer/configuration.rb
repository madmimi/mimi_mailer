module MimiMailer
  class Configuration < OpenStruct

    REQUIRED_KEYS = %w(username api_key default_from_address deliveries_enabled)

    def initialize(config = {})
      default_config = {
        username: nil,
        api_key: nil,
        default_from_address: nil,
        deliveries_enabled: true
      }

      config = default_config.merge(config)

      super config
    end

    def valid?
      REQUIRED_KEYS.each { |key| return false if send(key.to_sym).nil? }
      true
    end
  end
end
