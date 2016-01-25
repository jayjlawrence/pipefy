require "spec_helper"
require 'pipefy/config'

describe Pipefy::Config do
  config_keys = [ :email,
                  :token ]

  config_keys.each do |key|
    describe "##{key}" do
      it "can be set to a value" do
        Pipefy::Config.send("#{key}=","some string value")
        expect(Pipefy::Config.send(key)).to eq("some string value")
      end
    end
  end

  describe "#logger="do
    let(:logger) { Logger.new(STDOUT) }
    it "can set value" do
      Pipefy::Config.logger = logger
      expect(Pipefy::Config.logger).to eq(logger)
    end
  end
  
end
