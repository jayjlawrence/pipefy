module Pipefy
  class Phase
    attr_accessor :phase

    def initialize phase, parent_card = nil
      @phase = phase
      @parent_card = parent_card
    end

    def name
      @phase.name
    end

    def id
      @phase.id
    end

    def as_json
      phase.as_json
    end
  end
end