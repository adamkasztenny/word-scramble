# frozen_string_literal: true

require_relative '../../../app/persistence/word_repository'

RSpec.describe 'Word Repository' do
  it 'should return a random word with more than two letters' do
    repository = Persistence::WordRepository.new
    word = repository.get

    expect(word.size).to be > 2
  end
end
