module Pipefy
  class Config
    class << self
      attr_accessor :email,
                    :token

    end

    def self.logger
      @logger ||= Logger.new($stdout)
    end

    def self.logger= logger
      @logger=logger
    end

    def self.http_log= http_log
      @http_log=(http_log == 'true')
    end

    def self.http_log
      @http_log || false
    end
  end
end
