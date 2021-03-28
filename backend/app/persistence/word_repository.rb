# frozen_string_literal: true

module Persistence
  class WordRepository
    FILENAME = 'app/google-10000-english-no-swears.txt'

    def initialize
      @words = []
      initialize_words
    end

    def get
      @words.sample
    end

    private

    def initialize_words
      File.readlines(FILENAME).each do |line|
        word = line.chomp

        @words.push(word) if word.size > 2
      end
    end
  end
end
