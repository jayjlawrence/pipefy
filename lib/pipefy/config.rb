module Pipefy
  class Config
    class << self
      attr_accessor :email,
                    :token,
                    :http_log
    end

    def self.logger
      @logger ||= Logger.new($stdout)
    end

    def self.logger= logger
      @logger=logger
    end

  end
end
