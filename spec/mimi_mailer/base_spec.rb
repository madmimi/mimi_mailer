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

    subject { MimiMailer::Base }

    before do
      stub_request(:post, "https://api.madmimi.com/mailer")
      MimiMailer.config.stub(
        username: username, api_key: api_key, default_from_address: default_from)
      MimiMailer.stub(deliveries_enabled?: true)
      subject.stub(from_address: default_from)
    end

    it "posts to the correct API endpoint" do
      subject.mail(promotion_name, email_subject, to_address, body)
      expect(a_request(:post, "https://api.madmimi.com/mailer")).to have_been_requested
    end

    it "passes in the correct the username" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(username: username))

      subject.mail(promotion_name, email_subject, to_address, body)
      expect(request).to have_been_requested
    end

    it "passes in the correct the api_key" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(api_key: api_key))

      subject.mail(promotion_name, email_subject, to_address, body)
      expect(request).to have_been_requested
    end

    it "passes in the right subject" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(subject: email_subject))

      subject.mail(promotion_name, email_subject, to_address, body)
      expect(request).to have_been_requested
    end

    it "passes in the right promotion name" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(promotion_name: promotion_name))

      subject.mail(promotion_name, email_subject, to_address, body)
      expect(request).to have_been_requested
    end

    it "passes in the right recipient" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(recipient: to_address))

      subject.mail(promotion_name, email_subject, to_address, body)
      expect(request).to have_been_requested
    end

    it "passes in the yaml-converted body" do
      expected_body = body.to_yaml
      
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(body: expected_body))

      subject.mail(promotion_name, email_subject, to_address, body)
      expect(request).to have_been_requested
    end

    it "returns the Mimi transaction ID" do
      transaction_id = rand(1000)
      stub_request(:post, "https://api.madmimi.com/mailer").to_return(
        body: transaction_id.to_s)

      result = subject.mail(promotion_name, email_subject, to_address, body)
      expect(result).to eql(transaction_id)
    end

    it "passes in the right from address" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(from: default_from))

      result = subject.mail(promotion_name, email_subject, to_address, body)
      expect(request).to have_been_requested
    end

    context "when deliveries are disabled" do

      before { MimiMailer.stub(deliveries_enabled?: false) }

      it "does not post anything" do
        request = stub_request(:post, "https://api.madmimi.com/mailer")
        result = subject.mail(promotion_name, email_subject, to_address, body)
        expect(request).to_not have_been_requested
      end
    end
  end

  describe ".mail_plain_text" do
    let(:promotion_name) { "kittens" }
    let(:email_subject) { "omg kittens" }
    let(:to_address) { "dog@thepound.org" }
    let(:body) { "cats rule and dogs drool" }
    let(:username) { "cats@themansion.org" }
    let(:api_key)  { "apikey" }
    let(:default_from) { "catsinthecradle@themansion.com" }

    subject { MimiMailer::Base }

    before do
      stub_request(:post, "https://api.madmimi.com/mailer")
      MimiMailer.config.stub(
        username: username, api_key: api_key, default_from_address: default_from)
      MimiMailer.stub(deliveries_enabled?: true)
      subject.stub(from_address: default_from)
    end

    it "posts to the correct API endpoint" do
      subject.mail_plain_text(promotion_name, email_subject, to_address, body)
      expect(a_request(:post, "https://api.madmimi.com/mailer")).to have_been_requested
    end

    it "passes in the correct the username" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(username: username))

      subject.mail_plain_text(promotion_name, email_subject, to_address, body)
      expect(request).to have_been_requested
    end

    it "passes in the correct the api_key" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(api_key: api_key))

      subject.mail_plain_text(promotion_name, email_subject, to_address, body)
      expect(request).to have_been_requested
    end

    it "passes in the right subject" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(subject: email_subject))

      subject.mail_plain_text(promotion_name, email_subject, to_address, body)
      expect(request).to have_been_requested
    end

    it "passes in the right promotion name" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(promotion_name: promotion_name))

      subject.mail_plain_text(promotion_name, email_subject, to_address, body)
      expect(request).to have_been_requested
    end

    it "passes in the right recipient" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(recipient: to_address))

      subject.mail_plain_text(promotion_name, email_subject, to_address, body)
      expect(request).to have_been_requested
    end

    it "passes in the unmodified body" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(raw_plain_text: body))

      subject.mail_plain_text(promotion_name, email_subject, to_address, body)
      expect(request).to have_been_requested
    end

    it "returns the Mimi transaction ID" do
      transaction_id = rand(1000)
      stub_request(:post, "https://api.madmimi.com/mailer").to_return(
        body: transaction_id.to_s)

      result = subject.mail_plain_text(promotion_name, email_subject, to_address, body)
      expect(result).to eql(transaction_id)
    end

    it "passes in the right from address" do
      request = stub_request(:post, "https://api.madmimi.com/mailer").with(
        body: hash_including(from: default_from))

      result = subject.mail_plain_text(promotion_name, email_subject, to_address, body)
      expect(request).to have_been_requested
    end

    context "when deliveries are disabled" do
      before { MimiMailer.stub(deliveries_enabled?: false) }

      it "does not post anything" do
        request = stub_request(:post, "https://api.madmimi.com/mailer")
        result = subject.mail_plain_text(promotion_name, email_subject, to_address, body)
        expect(request).to_not have_been_requested
      end
    end
  end

  describe ".from_address" do
    it "sets the from address"
    it "returns the from address"
    it "returns the default from address is the class doesn't have its own"
  end
end
