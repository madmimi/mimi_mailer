module MimiMailer
  class Base
    include HTTParty
    base_uri 'https://api.madmimi.com'

    def self.from_address(new_address = nil)
      if new_address.nil?
        @from_address || MimiMailer.config.default_from_address || MimiMailer.config.username
      else
        @from_address = new_address
      end
    end

    def self.deliver(*args)
      raise NotImplementedError.new("#{self.class.name}.deliver must be overridden")
    end

    def self.mail(options = {})
      if MimiMailer.deliveries_enabled?
        check_config!

        options = default_options.merge(options)
        options[:recipient] = options.delete(:to) if options[:recipient].nil?
        options[:body] = options[:body].to_yaml unless options[:body].nil?

        mail_options_sanity_check! options

        response = post('/mailer', body: options)

        response.body.to_i
      end
    end

    def self.bulk_mail(options = {})
      if MimiMailer.deliveries_enabled?
        check_config!

        options = default_options.merge(options)
        options[:csv_file] = options.delete(:to) if options[:csv_file].nil?
        options[:body] = options[:body].to_yaml unless options[:body].nil?

        bulk_mail_options_sanity_check! options

        response = post('/mailer/to_imported_list', body: options)

        response.body.to_i
      end
    end

    def self.default_options
      @default_options.merge(
        username: MimiMailer.config.username,
        api_key:  MimiMailer.config.api_key,
        from:     from_address
      )
    end

  protected
    def self.check_config!
      raise MimiMailer::InvalidConfigurationError unless MimiMailer.config.valid?
    end

    def self.mail_options_sanity_check!(options)
      raise ArgumentError.new(":recipient or :to must be specified") if options[:recipient].nil?
      raise ArgumentError.new(":promotion_name must be specified") if options[:promotion_name].nil?
    end

    def self.bulk_mail_options_sanity_check!(options)
      raise ArgumentError.new(":csv_file or :to must be specified") if options[:csv_file].nil?
      raise ArgumentError.new(":audience_list must be specified") if options[:audience_list].nil?
      raise ArgumentError.new(":promotion_name must be specified") if options[:promotion_name].nil?
    end
  end
end
