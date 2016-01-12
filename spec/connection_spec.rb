require 'spec_helper'

describe Pipefy::Connection, :vcr => true do

  it 'lists pipes' do
    expect(subject.pipes.size).to eq(9)
  end

  it 'fetches pipe by id' do
    expect(subject.pipe(7915)).to include('name' => 'Loan Application')
  end

  it 'creates new cards' do
    expect(
      subject.create_card("Loan Application", "Demo Card", {"Scorecard" => "https://test.com/123"})
    ).to(include('title' => 'Demo Card'))
  end

end
