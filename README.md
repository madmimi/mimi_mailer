# MimiMailer

This gem provides a simple low-frills way to send transactional emails using the [Mad Mimi Mailer API](https://madmimi.com/developer/mailer/methods). If you need more, please check out our full-sized [madmimi gem](http://rubygems.org/gems/madmimi).

## Installation

Add this line to your application's Gemfile:

    gem 'mimi_mailer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mimi_mailer

## Usage

If you aren't using bundler,

```ruby
require "mimi_mailer"
```

and then configure the mailer to use your Mad Mimi API settings.

```ruby
MimiMailer.configure do |config|
  config.username = "you@example.com"
  config.api_key  = "your_api_key"
  config.default_from_address = "your default from address" # optional -- will use your username if not configured
end
```

Then, create a mailer class that subclasses `MimiMailer::Base`

```ruby
class UserWelcomeMailer < MimiMailer::Base
  from_address 'someone@example.com' # A class-specific from address

  def self.deliver(user)
    mail('user_welcome', '')
  end
end

```

### MimiMailer::Base.mail

The `MimiMailer::Base.mail` method has this signature:

```ruby
mail(promotion_name, subject, to_address, body = {})
```

The body hash contains keys and values that will be substituted into correspoding promotion placeholders. Please refer to our [transactional email documentation](https://madmimi.com/developer/mailer/transactional) for more info.

### MimiMailer::Base.mail_plain_text

The `MimiMailer::Base.mail_plain_text` method has this signature:

```ruby
mail(promotion_name, subject, to_address, body)
```

The body parameter specifies the full plain-text body for your email.

## Limitations

* Only supports one recipient per mailing
* Only one from address is supported per mailer
* No raw HTML support
