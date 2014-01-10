module MimiMailer
  class Error < StandardError; end

  class Base
    include HTTParty
    base_uri 'https://api.madmimi.com'

    def self.deliver(object_id, args)
      raise NotImplementedError.new("#{self.class.name}#deliver must be overriden")
    end

    def self.mail(promotion_name, subject, to_address, body = {})
      return rand(20_000_000_000) unless MimiMailer.deliveries_enabled?

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

    def self.mail_plain_text(promotion_name, subject, to_address, body)
      return rand(20_000_000_000) unless MimiMailer.deliveries_enabled?

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