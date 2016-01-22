require 'spec_helper'

describe Pipefy::Connection, :vcr => true do

  it 'lists pipes' do
    expect(subject.pipes.size).to be > 4
  end

  it 'fetches pipe by id' do
    expect(subject.pipe(7915)).to include('name' => 'Loan Application')
  end

  it 'creates new cards' do
    expect(
      subject.create_card(33176, "Demo Card", {})
    ).to(include('title' => 'Demo Card'))
  end

  it 'throws error when create card fails' do
    expect {subject.create_card(1, "FAIL", {}) }.to raise_error
  end

end
