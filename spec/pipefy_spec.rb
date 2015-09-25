require 'spec_helper'

describe Pipefy, :vcr => true do
  it 'has a version number' do
    expect(Pipefy::VERSION).not_to be nil
  end

  it 'knows me' do
    expect(subject.me).to include('username' => 'mikegrassotti')
  end

  it 'lists pipes' do
    expect(subject.pipes.size).to eq(4)
  end

  it 'fetches pipe by id' do
    expect(subject.pipe(15267)).to include('name' => 'Scorecard')
  end

end
