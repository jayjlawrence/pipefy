module Pipefy
  class ConnectedPipe
    attr_reader :id, :name, :connected_pipe, :parent_card

    def initialize connected_pipe, parent_card
      @connected_pipe = connected_pipe
      @parent_card = parent_card
    end

    def id
      @connected_pipe.pipe.id
    end

    def name
      @connected_pipe.pipe.name
    end

    def create_card title
      begin
        pipefy.create_connected_card parent_card.id, connected_pipe.pipe.id, { 873499 => title }
      rescue => e
        raise e
      end
    end

    def pipefy
      @pipefy ||= Pipefy::Connection.new
    end
  end
end