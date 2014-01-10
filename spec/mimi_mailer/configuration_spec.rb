require 'spec_helper'

describe MimiMailer::Configuration do
  describe "value setting and retrieval" do
    subject { MimiMailer::Configuration.new }

    it "works with method syntax" do
      username = "user@example.com"
      subject.username = username
      expect(subject.username).to eql(username)
    end

    it "works when setting initial values on initialization" do
      username = "user@example.com"
      subject = MimiMailer::Configuration.new(username: username)
      expect(subject.username).to eql(username)
    end
  end

  describe "valid?" do
    context "valid config" do
      subject { MimiMailer::Configuration.new(username: "user@example.com",
                                              api_key: "key",
                                              default_from_address: "addy@example.com") }

      it "returns true if all required config is set" do
        expect(subject.valid?).to be_true
      end
    end

    context "invalid config" do
      subject { MimiMailer::Configuration.new }

      it "returns false if a required option is not set" do
        expect(subject.valid?).to be_false
      end
    end
  end
end