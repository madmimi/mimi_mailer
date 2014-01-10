require 'spec_helper'

describe MimiMailer do
  context 'configuration' do
    describe '.configure' do
      it "raises an error if a block is not supplied" do
        expect {
          MimiMailer.configure
        }.to raise_error(ArgumentError)
      end

      it "yeilds a MimiMailer::Configuration object" do
        expect { |b|
          MimiMailer.configure(&b)
        }.to yield_with_args(MimiMailer::Configuration)
      end
    end

    describe ".config" do
      it "returns a MimiMailer::Configuration object" do
        expect(MimiMailer.config).to be_a(MimiMailer::Configuration)
      end

      it "returns the same MimiMailer::Configuration object on subsequent calls" do
        config = MimiMailer.config
        expect(MimiMailer.config).to equal(config)
      end
    end

    describe ".enable_deliveries!" do
      it "sets MimiMailer.config.deliveries_enabled to true" do
        MimiMailer.config.deliveries_enabled = false
        expect {
          MimiMailer.enable_deliveries!
        }.to change { MimiMailer.config.deliveries_enabled }.to(true)
      end
    end

    describe ".disable_deliveries!" do
      it "sets MimiMailer.config.deliveries_enabled to false" do
        MimiMailer.config.deliveries_enabled = true
        expect {
          MimiMailer.disable_deliveries!
        }.to change { MimiMailer.config.deliveries_enabled }.to(false)
      end
    end
  end
end