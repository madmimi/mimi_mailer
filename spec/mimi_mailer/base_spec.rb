require 'spec_helper'

describe MimiMailer::Base do
  describe ".deliver" do
    class TestMailer < MimiMailer::Base; end

    subject { TestMailer }

    it "raies an error if not implemented" do
      expect {
        subject.deliver
      }.to raise_error(NotImplementedError, /overridden/i)
    end
  end

  describe ".mail" do
    let(:promotion_name) { "kittens" }
    let(:email_subject) { "omg kittens" }
    let(:to_address) { "dog@thepound.org" }
    let(:body) { { cats: "rule", dogs: "drool" } }
    let(:username) { "cats@themansion.org" }
    let(:api_key)  { "apikey" }
    let(:default_from) { "catsinthecradle@themansion.com" }
    let(:default_options) {
      {
        promotion_name: promotion_name,
        to: to_address,
        from: default_from,
        subject: email_subject
      }
    }

    subject { MimiMailer::Base }

    before do
      stub_request(:post, "https://api.madmimi.com/mailer")
      MimiMailer.config.stub(
        username: username, api_key: api_key, default_from_address: default_from)
      MimiMailer.stub(deliveries_enabled?: true)
      subject.stub(from_address: default_from)
    end

    it "raises an error if the config is not valid" do
      MimiMailer.config.stub(valid?: false)
      expect {
        subject.mail(default_options)
      }.to raise_error(MimiMailer::InvalidConfigurationError)
    end

    it "raises an error if :to is not specified" do
      default_options.delete(:to)
      expect {
        subject.mail(default_options)
      }.to raise_error(ArgumentError, /to.+specified/i)
    end

    it "raises an error if :promotion_name is not specified" do
      default_options.delete(:promotion_name)
      expect {
        subject.mail(default_options)
      }.to raise_error(ArgumentError, /promotion_name.+specified/i)
    end

    it "posts to the correct API endpoint" do
      subject.mail(default_options)
      expect(a_request(:post, "https://api.madmimi.com/mailer")).to have_been_requested
    end

    it "passes in the correct the username" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(username: username))

      subject.mail(default_options)
      expect(request).to have_been_requested
    end

    it "passes in the correct the api_key" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(api_key: api_key))

      subject.mail(default_options)
      expect(request).to have_been_requested
    end

    it "passes in the right subject" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(subject: email_subject))

      subject.mail(default_options)
      expect(request).to have_been_requested
    end

    it "passes in the right promotion name" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(promotion_name: promotion_name))

      subject.mail(default_options)
      expect(request).to have_been_requested
    end

    it "passes in the right recipient" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(recipient: to_address))

      subject.mail(default_options)
      expect(request).to have_been_requested
    end

    context "when it contains a :body parameter" do
      let(:options) { default_options.merge(body: body) }

      it "passes in the yaml-converted body" do
        expected_body = body.to_yaml
        
        request = stub_request(:post, "https://api.madmimi.com/mailer").with(
          body: hash_including(body: expected_body))

        subject.mail(options)
        expect(request).to have_been_requested
      end
    end

    context "when it contains a :raw_plain_text parameter" do
      let(:raw_plain_text) { "Cameron the cat would never miss a trick" }
      let(:options) { default_options.merge(raw_plain_text: raw_plain_text) }

      it "passes in the unmodified body" do
        request = stub_request(:post, "https://api.madmimi.com/mailer").with(
          body: hash_including(raw_plain_text: raw_plain_text))

        subject.mail(options)
        expect(request).to have_been_requested
      end
    end

    context "when it contains a :raw_html parameter" do
      let(:raw_html) { "<h1>OMG KITTENS</h1>" }
      let(:options) { default_options.merge(raw_html: raw_html) }

      it "passes in the unmodified body" do
        request = stub_request(:post, "https://api.madmimi.com/mailer").with(
          body: hash_including(raw_html: raw_html))

        subject.mail(options)
        expect(request).to have_been_requested
      end
    end

    it "returns the Mimi transaction ID" do
      transaction_id = rand(1000)
      stub_request(:post, "https://api.madmimi.com/mailer").to_return(
        body: transaction_id.to_s)

      result = subject.mail(default_options)
      expect(result).to eql(transaction_id)
    end

    it "passes in the right from address" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(from: default_from))

      result = subject.mail(default_options)
      expect(request).to have_been_requested
    end

    context "when deliveries are disabled" do
      before { MimiMailer.stub(deliveries_enabled?: false) }

      it "does not post anything" do
        request = stub_request(:post, "https://api.madmimi.com/mailer")
        result = subject.mail(default_options)
        expect(request).to_not have_been_requested
      end
    end
  end

  describe ".from_address" do
    class MailerWithFromAddress < MimiMailer::Base
      from_address 'tomcat@example.com'
    end

    class MailerWithOtherFromAddress < MimiMailer::Base
      from_address 'harrycat@example.com'
    end

    class MailerWithoutFromAddress < MimiMailer::Base
    end

    let(:default_from) { 'socks@whitehouse.gov' }

    before { MimiMailer.config.stub(default_from_address: default_from) }

    it "sets and returns the configured class from address" do
      expect(MailerWithFromAddress.from_address).to eql('tomcat@example.com')
    end

    it "returns the default from address if the class doesn't have its own" do
      expect(MailerWithoutFromAddress.from_address).to eql(default_from)
    end

    it "does not return another class' email address" do
      expect(MailerWithFromAddress.from_address).to eql('tomcat@example.com')
      expect(MailerWithOtherFromAddress.from_address).to eql('harrycat@example.com')
    end

    it "returns the username if default_from_address is not configured" do
      username = "kittycat@example.com"
      MimiMailer.config.unstub(:default_from_address)
      MimiMailer.config.stub(username: username)
      expect(MailerWithoutFromAddress.from_address).to eql(username)
    end
  end
end
