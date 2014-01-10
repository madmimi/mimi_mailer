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

    def self.mail(promotion_name, subject, to_address, body = {})
      if MimiMailer.deliveries_enabled?
        check_config!

        response = post('/mailer', body: {
          username:       MimiMailer.config.username,
          api_key:        MimiMailer.config.api_key,
          recipient:      to_address,
          subject:        subject,
          from:           MimiMailer.config.default_from_address,
          promotion_name: promotion_name,
          body:           body.to_yaml
        })
        
        response.body.to_i
      end
    end

    def self.mail_plain_text(promotion_name, subject, to_address, body)
      if MimiMailer.deliveries_enabled?
        check_config!
        
        response = post('/mailer', body: {
          username:       MimiMailer.config.username,
          api_key:        MimiMailer.config.api_key,
          recipient:      to_address,
          subject:        subject,
          from:           MimiMailer.config.default_from_address,
          promotion_name: promotion_name,
          raw_plain_text: body
        })
        
        response.body.to_i
      end
    end


  protected
    def self.check_config!
      raise MimiMailer::InvalidConfigurationError unless MimiMailer.config.valid?
    end
  end
end