require 'spec_helper'

describe Pipefy::Connection, :vcr => true do

  it 'lists pipes' do
    expect(subject.find_pipes.size).to be > 4
  end

  it 'fetches pipe by id' do
    expect(subject.find_pipe(7915)).to include('name' => 'Loan Application')
  end

  it 'creates new cards' do
    expect(
      subject.create_card(33176, "Demo Card", {})
    ).to(include('title' => 'Demo Card'))
  end

  it 'creates connected cards' do
    parent_card_id = 407309
    pipe_id = 33012
    data = {
      816556 => "Donald Trump",
      816557 => "123456789",
      816558 => 123,
      816559 => 1234,
      816560 => "POTUS",
      816561 => "Washington DC"
    }
    # create_connected_card parent_card_id, pipe_id, data
    body = subject.create_connected_card(parent_card_id, pipe_id, data)

    expect(body).to include('can_show_pipe', 'current_phase_detail', 'current_phase_id',
                            'done', 'draft', 'due_date', 'duration', 'expiration_time',
                            'expired', 'finished_at', 'id', 'index', 'labels', 'late',
                            'pipe', 'started_at', 'title')
  end

  it 'throws error when create card fails' do
    expect {subject.create_card(1, "FAIL", {}) }.to raise_error
  end

  describe "#default_config" do
    subject { Pipefy::Connection.new.send(:default_config) }
    it { is_expected.to include(:email, :token) }
  end
end
