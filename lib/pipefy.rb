require 'faraday'
require 'faraday_middleware'
require "pipefy/version"
require "pipefy/connection"

module Pipefy
  def self.me
    Pipefy::Connection.new.me
  end
  def self.pipes
    Pipefy::Connection.new.pipes
  end
  def self.pipe id
    Pipefy::Connection.new.pipe(id)
  end
  def self.create_card pipe_name, card_title, field_data={}
    conn = Pipefy::Connection.new
    pipes = conn.get("/pipes").body
    selected_pipe = pipes.find{|item| item["name"] === pipe_name}
    raise "Cannot find pipe named '#{pipe_name}'. The available pipes are #{ pipes.map {|p| p["name"]} }" if selected_pipe.nil?
    pipe_id = selected_pipe["id"]
    pipe = conn.get("pipes/#{pipe_id}").body
    phase_id = pipe["phases"].first["id"]
    phase = conn.get("/phases/#{phase_id}").body
    field_values_array = field_data.map do |key, value|
      field = phase["fields"].find {|field| field["label"] === key}
      raise "Cannot find field label '#{key}' in '#{pipe_name}:#{phase["name"]}'. The available fields are #{phase["fields"].map {|o| o["label"]}}" if field.nil?
      {field_id: field["id"], value: value}
    end
    card_data = {"card" => {"title" => card_title, field_values: field_values_array}};
    results = conn.post "/pipes/#{pipe_id}/create_card", card_data
    results.body
  end
end
