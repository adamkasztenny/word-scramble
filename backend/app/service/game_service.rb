# frozen_string_literal: true

require 'securerandom'
require_relative '../../app/persistence/answer_repository'

module Service
  class GameService
    def initialize(word_repository, word_scrambler, answer_repository)
      @word_repository = word_repository
      @word_scrambler = word_scrambler
      @answer_repository = answer_repository
    end

    def ask_question
      word = @word_repository.get
      scrambled_word = @word_scrambler.scramble(word)
      id = SecureRandom.uuid

      @answer_repository.add(id, word)
      { scrambled_word: scrambled_word, id: id }
    end

    def answer_question(id, answer)
      correct = @answer_repository.get(id) == answer
      result = { correct: correct, points: 0 }

      if correct
        @answer_repository.remove(id)
        result[:points] = answer.size
      end

      result
    end

    def question_exists?(id)
      @answer_repository.exists?(id)
    end

    def skip_question(id)
      return unless question_exists?(id)

      word = @answer_repository.get(id)
      @answer_repository.remove(id)

      { 'points': -1 * word.size }
    end
  end
end
