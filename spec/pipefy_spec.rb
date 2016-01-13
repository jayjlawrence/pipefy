require 'spec_helper'

describe Pipefy, :vcr => true do
  it 'has a version number' do
    expect(Pipefy::VERSION).not_to be nil
  end

  it 'lists pipes' do
    expect(subject.pipes.size).to be > 4 
  end

end
