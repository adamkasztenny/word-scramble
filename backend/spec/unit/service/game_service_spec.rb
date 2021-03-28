# frozen_string_literal: true

require_relative '../../../app/service/game_service'
require 'uuid'

RSpec.describe 'Game Service' do
  let(:word) { 'thing' }
  let(:scrambled_word) { 'ghtin' }
  let(:answer_repository) { double('answer_repository') }

  context 'Asking Questions' do
    it 'should return a question with a scrambled word' do
      service = create_service

      result = service.ask_question

      expect(result[:scrambled_word]).to be(scrambled_word)
    end

    it 'should return a question with a continuation UUID' do
      service = create_service

      result = service.ask_question

      id = result[:id]
      expect(id).not_to be_nil
      UUID.validate(id)
    end

    it 'should a store the answer' do
      service = create_service
      expect(answer_repository).to receive(:add).with(anything, word)

      service.ask_question
    end
  end

  context 'Answering Questions' do
    it 'should return true if the word was answered correctly' do
      service = create_service
      question = service.ask_question
      correct_answer = word
      expect(answer_repository).to receive(:get).with(question[:id]).and_return(word)

      result = service.answer_question(question[:id], correct_answer)

      expect(result[:correct]).to be true
    end

    it 'should return the points gained, corresponding to the word length, if the question was answered correctly' do
      service = create_service
      question = service.ask_question
      correct_answer = word
      expect(answer_repository).to receive(:get).with(question[:id]).and_return(word)

      result = service.answer_question(question[:id], correct_answer)

      expect(result[:points]).to be word.size
    end

    it 'should delete the question, if the question was answered correctly' do
      service = create_service
      question = service.ask_question
      correct_answer = word
      expect(answer_repository).to receive(:get).with(question[:id]).and_return(word)
      expect(answer_repository).to receive(:remove).with(question[:id])

      service.answer_question(question[:id], correct_answer)
    end

    it 'should return false if the word was answered incorrectly' do
      service = create_service
      question = service.ask_question
      incorrect_answer = 'wrong'
      expect(answer_repository).to receive(:get).with(question[:id]).and_return(word)

      result = service.answer_question(question[:id], incorrect_answer)

      expect(result[:correct]).to be false
    end

    it 'should return zero points if the word was answered incorrectly' do
      service = create_service
      question = service.ask_question
      incorrect_answer = 'wrong'
      expect(answer_repository).to receive(:get).with(question[:id]).and_return(word)

      result = service.answer_question(question[:id], incorrect_answer)

      expect(result[:points]).to be 0
    end

    it 'should return false if question ID does not exist' do
      service = create_service
      non_existant_id = 'non-existant-id'
      answer = 'irrelevant'
      expect(answer_repository).to receive(:get).with(non_existant_id).and_return(nil)

      result = service.answer_question(non_existant_id, answer)

      expect(result[:correct]).to be false
    end
  end

  context 'Checking if Questions Exist' do
    it 'should return true if the question exists' do
      service = create_service
      question = service.ask_question
      expect(answer_repository).to receive(:exists?).with(question[:id]).and_return(true)

      result = service.question_exists?(question[:id])

      expect(result).to be true
    end

    it 'should return false if the question does not exist' do
      service = create_service
      non_existant_id = 'non-existant-id'
      expect(answer_repository).to receive(:exists?).with(non_existant_id).and_return(false)

      result = service.question_exists?(non_existant_id)

      expect(result).to be false
    end
  end

  context 'Skipping a Question' do
    it 'should delete the question' do
      service = create_service
      question = service.ask_question

      allow(answer_repository).to receive(:exists?).with(question[:id]).and_return(true)
      expect(answer_repository).to receive(:get).with(question[:id]).and_return(word)
      expect(answer_repository).to receive(:remove).with(question[:id])

      service.skip_question(question[:id])
    end

    it 'should return the points that were lost (expressed as a negative value), corresponding to the word length' do
      service = create_service
      question = service.ask_question

      allow(answer_repository).to receive(:exists?).with(question[:id]).and_return(true)
      expect(answer_repository).to receive(:get).with(question[:id]).and_return(word)

      result = service.skip_question(question[:id])

      expect(result[:points]).to be(-1 * word.size)
    end

    it 'should do nothing if the question id does not exist' do
      service = create_service
      non_existant_id = 'non-existant-id'
      expect(answer_repository).to receive(:exists?).with(non_existant_id).and_return(false)

      expect(service.skip_question(non_existant_id)).to be nil
    end
  end

  private

  def create_service
    word_repository = double('word_repository')
    allow(word_repository).to receive(:get).and_return(word)

    allow(answer_repository).to receive(:add).with(any_args)
    allow(answer_repository).to receive(:remove).with(any_args)

    word_scrambler = double('word_scrambler')
    allow(word_scrambler).to receive(:scramble).and_return(scrambled_word)

    Service::GameService.new(word_repository, word_scrambler, answer_repository)
  end
end
