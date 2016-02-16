module Pipefy

  class Pipe
    attr_reader :connected_pipe

    def initialize connected_pipe, parent_card
      @connected_pipe = connected_pipe
      @parent_card = parent_card
    end

    
  end
end