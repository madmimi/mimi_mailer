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

Then, create a mailer class that subclasses `MimiMailer::Base` and implements a delivery method like so:

```ruby
class UserWelcomeMailer < MimiMailer::Base
  from_address 'someone@example.com' # A class-specific from address

  def self.deliver(user)
    mail(promotion_name: 'promotion_name', to: user.email, subject: "subject", body: { name: user.name })
  end
end

```

### MimiMailer::Base.mail

`MimiMailer::Base.mail` accepts the following options:

```ruby
{
  # Required. The name of the Mad Mimi promotion you want to send
  promotion_name: 'promotion_name',

  # Required. Who you want to send the email to. Also may be specified with :recipient.
  to: 'someone@example.com',

  # Who you want the email to be from. If not specified, this will fall back to the
  # class-specific from address or the configured default_from_address
  from: 'you@example.com',

  # The subject of the email
  subject: 'A nice email',

  # Placeholders that will be merged into a composed promotion on Mad Mimi. :raw_html
  # and/or :raw_plain_text may be specified instead (see below)
  body: {
    first_name: user.first_name,
    last_name: user.last_name
  }
}
```

### MimiMailer::Base.bulk_mail

`MimiMailer::Base.bulk_mail` accepts the following options:

```ruby
{
  # Required. The name of the Mad Mimi promotion you want to send
  promotion_name: 'promotion_name',

  # Required. The name of the audience list to import into and send to.
  audience_list: 'audience_list',

  # Required. The email recipients list in CSV format. Also may be specified with :csv_file.
  to: "email,first name,last name,car\ndave@example.com,Dave,Hoover,Ford\ncolin@example.com,Colin,Harris,Chevy",

  # Who you want the email to be from. If not specified, this will fall back to the
  # class-specific from address or the configured default_from_address
  from: 'you@example.com',

  # The subject of the email
  subject: 'A nice email',

  # Placeholders that will be merged into a composed promotion on Mad Mimi. :raw_html
  # and/or :raw_plain_text may be specified instead (see below)
  body: {
    first_name: user.first_name,
    last_name: user.last_name
  }
}
```

### Email body

The email contents can be specified using **either**:

`:body`

The body hash contains keys and values that will be substituted into correspoding promotion placeholders.

**or**

`:raw_html`

The raw HTML body of the email. May be used in conjunction with `:raw_plain_text`.

`:raw_plain_text`

The raw plain text body of the email. May be used in conjunction with `:raw_html`.

Please take a look at our [transactional email API guide](https://madmimi.com/developer/mailer/transactional) for more information about these and other options.
