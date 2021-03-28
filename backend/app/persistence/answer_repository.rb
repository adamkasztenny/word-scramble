# frozen_string_literal: true

module Persistence
  class AnswerRepository
    MAXIMUM_CURRENT_QUESTIONS = 1000

    def initialize
      @answers = {}
    end

    def add(id, original_word)
      @answers[id] = original_word if @answers.size < MAXIMUM_CURRENT_QUESTIONS
    end

    def remove(id)
      @answers.delete(id)
    end

    def get(id)
      @answers[id]
    end

    def exists?(id)
      !@answers[id].nil?
    end
  end
end
