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

  describe "#http_log" do
    it "is false when set to nil" do
      Pipefy::Config.http_log=nil
      expect(Pipefy::Config.http_log).to eq(false)
    end
    it "can be set to true with a true string" do
      Pipefy::Config.http_log="true"
      expect(Pipefy::Config.http_log).to eq(true)
    end
    it "is set to false with not a true string" do
      ["false", "no", nil, ""].each do |value|
        Pipefy::Config.http_log=value
        expect(Pipefy::Config.http_log).to eq(false)
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
