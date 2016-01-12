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
end
