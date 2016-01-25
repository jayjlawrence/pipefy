require 'awesome_print'

module Pipefy
  class Connection
    attr_reader :headers, :conn
    def initialize config={}
      @config = default_config.merge(config)
      validate_config

      @headers = {
        'X-User-Email' => @config[:email],
        'X-User-Token' => @config[:token],
        'Accept' => 'application/json'
      }

      @conn = Faraday.new(:url => 'https://app.pipefy.com', headers: headers ) do |faraday|
        faraday.request  :json
        faraday.response :mashify
        faraday.response :json
        faraday.response :logger if ENV['PIPEFY_HTTP_LOG']
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.use Faraday::Response::RaiseError
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end


    def me
      get("/users/current")
    end
    def find_card id
      get("/cards/#{id}")
    end
    def find_cards id
      get("/cards")
    end
    def find_pipe id
      get("/pipes/#{id}")
    end
    def find_pipes
      get("/pipes")
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
      ccard = post("/cards/#{parent_card_id}/create_connected_card", 'pipe_id' => pipe_id)
      #Lookup card_phase_detail_id for the card that we just created
      pcard = find_card(parent_card_id)
      _details = pcard.current_phase_detail.connected_cards.find {|c| c.id === ccard.id}
      card_phase_detail_id = _details.current_phase_detail.id
      #Set field value(s) as needed
      fields.each do |key, value| 
        data = {card_field_value: {field_id: key, card_phase_detail_id: card_phase_detail_id, value: value}}
        post("/card_field_values", data)
      end
      #Move connected card out of draft phase
      put("/cards/#{ccard_id}/next_phase")
    end
    def create_card pipe_id, card_title, field_data={}
      _pipe = find_pipe(pipe_id)
      phase_id = _pipe.phases.first.id
      phase = get("/phases/#{phase_id}")
      field_values_array = field_data.map do |key, value|
        field = phase["fields"].find {|field| field["label"] === key}
        raise "Cannot find field label '#{key}' in '#{pipe_name}:#{phase["name"]}'. The available fields are #{phase["fields"].map {|o| o["label"]}}" if field.nil?
        {field_id: field["id"], value: value}
      end
      card_data = {"card" => {"title" => card_title, field_values: field_values_array}};
      post("/pipes/#{pipe_id}/create_card", card_data)
    end
    def jump_to_phase card_id, phase_id
      put("/cards/#{card_id}/jump_to_phase/#{phase_id}")
    end

    protected

    def get *args
      @conn.send(:get, *args).body
    end
    def post *args
      @conn.send(:post, *args).body
    end
    def put *args
      @conn.send(:put, *args).body
    end

    private 
      def default_config
        {
          email: Pipefy::Config.email,
          token: Pipefy::Config.token
        }
      end

      def validate_config
        [:email, :token].each do |key|
          raise "Pipefy #{key} required" if @config[key].nil?
        end
      end
  end
end
