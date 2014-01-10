module MimiMailer
  class Base
    include HTTParty
    base_uri 'https://api.madmimi.com'

    def self.from_address(new_address = nil)
      if new_address.nil?
        @from_address || MimiMailer.config.default_from_address
      else
        @from_address = new_address
      end
    end

    def self.deliver(*args)
      raise NotImplementedError.new("#{self.class.name}.deliver must be overridden")
    end

    def self.mail(promotion_name, subject, to_address, body = {})
      if MimiMailer.deliveries_enabled?
        response = post('/mailer', body: {
          username:       MimiMailer.config.username,
          api_key:        MimiMailer.config.api_key,
          recipient:      to_address,
          subject:        subject,
          from:           MimiMailer.config.default_from_address,
          promotion_name: promotion_name,
          body:           body.to_yaml
        })
        transaction_id = response.body.to_i
        transaction_id
      end
    end

    def self.mail_plain_text(promotion_name, subject, to_address, body)
      if MimiMailer.deliveries_enabled?
        response = post('/mailer', body: {
          username:       MimiMailer.config.username,
          api_key:        MimiMailer.config.api_key,
          recipient:      to_address,
          subject:        subject,
          from:           MimiMailer.config.default_from_address,
          promotion_name: promotion_name,
          raw_plain_text: body
        })
        transaction_id = response.body.to_i
        transaction_id
      end
    end
  end
end