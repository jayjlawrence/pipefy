require 'awesome_print'

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
      #TODO: Raise error unless we get a 200 response
      @conn.send(:get, *args)
    end
    def post *args
      #TODO: Raise error unless we get a 201 response
      @conn.send(:post, *args)
    end
    def put *args
      #TODO: Raise error unless we get a 200 response
      @conn.send(:put, *args)
    end
    def card id
      @conn.get("/cards/#{id}").body
    end
    def create_guarantor_background_check parent_card_id, name, ssn, loan_application_id, guarantor_id, company_name, address
      pipe_id = 33012
      data = {
        816556 => name,
        816557 => ssn,
        816558 => loan_application_id,
        816559 => guarantor_id,
        816560 => company_name,
        816561 => address
      }
      create_connected_card parent_card_id, pipe_id, data
    end
    def create_connected_card parent_card_id, pipe_id, fields={}
      #Create connected card in draft mode
      ccard = post("/cards/#{parent_card_id}/create_connected_card", 'pipe_id' => pipe_id).body
      ccard_id = ccard["id"]
      #Lookup card_phase_detail_id for the card that we just created
      pcard = card parent_card_id
      _details = pcard["current_phase_detail"]["connected_cards"].find {|c| c["id"] === ccard["id"]}
      card_phase_detail_id = _details["current_phase_detail"]["id"]
      #Set field value(s) as needed
      fields.each do |key, value| 
        data = {card_field_value: {field_id: key, card_phase_detail_id: card_phase_detail_id, value: value}}
        "posting card-field-values:"
        post("/card_field_values", data)
      end
      #Move connected card out of draft phase
      put("/cards/#{ccard_id}/next_phase")
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
