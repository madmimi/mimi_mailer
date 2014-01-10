require 'spec_helper'

describe MimiMailer do
  context 'configuration' do
    describe '.configure' do
      it "requires a block"
      it "passes a config object"
      describe "config object" do
        it "supports .key = value notation"
        it "supports [:key] = value notation"
      end
    end
  end
end