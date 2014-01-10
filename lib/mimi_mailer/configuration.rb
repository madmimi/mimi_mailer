module MimiMailer
  class Configuration < OpenStruct

    REQUIRED_KEYS = %w(username api_key default_from_address)

    def initialize(config = {})
      default_config = {
        username: nil,
        api_key: nil,
        default_from_address: nil
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
