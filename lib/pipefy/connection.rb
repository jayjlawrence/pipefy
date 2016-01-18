module Pipefy
  class Connection
    attr_reader :headers, :conn
    def initialize email=nil,token=nil
      # puts "hello"
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
    def put *args
      @conn.send(:put, *args)
    end
    def create_card pipe_id, card_title, field_data={}
      _pipe = pipe(pipe_id)
      phase_id = _pipe["phases"].first["id"]
      phase = get("/phases/#{phase_id}").body
      field_values_array = field_data.map do |key, value|
        field = phase["fields"].find {|field| field["label"] === key}
        raise "Cannot find field label '#{key}' in '#{pipe_name}:#{phase["name"]}'. The available fields are #{phase["fields"].map {|o| o["label"]}}" if field.nil?
        {field_id: field["id"], value: value}
      end
      card_data = {"card" => {"title" => card_title, field_values: field_values_array}};
      results = @conn.post "/pipes/#{pipe_id}/create_card", card_data
      results.body
    end
    def jump_to_phase card_id, phase_id
      res = @conn.put("/cards/#{card_id}/jump_to_phase/#{phase_id}")
      if res.status === 422
        raise res.body
      else
        return res.body
      end
    end
  end
end
