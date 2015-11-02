module Pipefy
  class Connection
    attr_reader :headers, :conn
    def initialize email=nil,token=nil
      email ||= ENV['PIPEFY_EMAIL']
      token ||= ENV['PIPEFY_TOKEN']
      raise "Pipefy email required" if email.nil?
      raise "Pipefy token required" if token.nil?
      @headers = {
        'X-User-Email' => email,
        'X-User-Token' => token,
        'Accept' => 'application/json'
      }
      @conn = Faraday.new(:url => 'https://app.pipefy.com', headers: headers ) do |faraday|
        faraday.request  :json
        faraday.response :json, :content_type => /\bjson$/
        faraday.response :logger if ENV['PIPEFY_HTTP_LOG']
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
    def me
      @conn.get("/users/current").body
    end
    def pipes
      @conn.get("/pipes").body
    end
    def pipe id
      @conn.get("/pipes/#{id}").body
    end
    def get *args
      @conn.send(:get, *args)
    end
    def post *args
      @conn.send(:post, *args)
    end
  end
end
