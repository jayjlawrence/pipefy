module Pipefy
  class Config
    class << self
      attr_accessor :email, :token
    end

    def self.logger
      @logger ||= Logger.new($stdout)
    end

    def self.logger= logger
      @logger=logger
    end

  end
end
