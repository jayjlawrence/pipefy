module Pipefy
  class Card
    attr_reader :pipefy_card_id

    def initialize pipefy_card_id
      @pipefy_card_id = pipefy_card_id
    end

    def id
      pipefy_card.id
    end

    def title
      pipefy_card.title
    end

    def previous_phase
      pipefy_card.previous_phase
    end

    def next_phase
      pipefy_card.next_phase
    end

    def current_phase
      pipefy_card.current_phase_detail
    end

    def move_to target_phase_id
      # ap target_phase
      phase = pipefy.jump_to_phase pipefy_card_id, target_phase_id
      # if current_phase.id == target_phase.id
      @pipefy_card = pipefy_card.find_card pipefy_card_id 
    end

    def connected_pipes
      pipefy_card.current_phase_detail.phase.pipe_connections.map do |pipe|
        ConnectedPipe.new pipe, self
      end
    end

    def connected_pipe id
      connected_pipes.find { |pipe| pipe.id == id }
    end

    def connected_cards
      @pipefy_card = nil
      pipefy_card.current_phase_detail.connected_cards.map do |card|
        Card.new card.id
      end
    end

    def other_phase_details
      pipefy_card.other_phase_details.map do |phase|
        # puts "phase"
        # ap phase
        phase
      end
    end

    def pipe
      pipefy_card.pipe
    end

    def pipefy_card
      @pipefy_card ||= pipefy.find_card pipefy_card_id
    end

    def as_json
      {
        id: id,
        phases: other_phase_details
      }
    end

    def pipefy
      @pipefy ||= Pipefy::Connection.new
    end
  end
end