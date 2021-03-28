# frozen_string_literal: true

module Domain
  class WordScrambler
    def self.scramble(word)
      scrambled_word = word.split('').shuffle.join('')
      return scramble(word) if scrambled_word == word

      scrambled_word
    end
  end
end
