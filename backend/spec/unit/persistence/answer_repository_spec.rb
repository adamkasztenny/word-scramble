# frozen_string_literal: true

require_relative '../../../app/persistence/answer_repository'

RSpec.describe 'Answer Repository' do
  let(:original_word) { 'some word' }
  let(:id) { 'some id' }
  let(:non_existant_id) { 'non-existant-id' }

  it 'should store answers' do
    repository = create_respository
    expect(repository.exists?(id)).to be false

    repository.add(id, original_word)

    expect(repository.exists?(id)).to be true
  end

  it 'should remove answers' do
    repository = create_respository
    repository.add(id, original_word)
    expect(repository.exists?(id)).to be true

    repository.remove(id)

    expect(repository.exists?(id)).to be false
  end

  it 'should return an answer for an existing ID' do
    repository = create_respository
    repository.add(id, original_word)

    expect(repository.get(id)).to be original_word
  end

  it 'should return nil when retreiving a non-existant ID' do
    repository = create_respository

    expect(repository.get(id)).to be nil
  end

  it 'should return indicate that an answer exists' do
    repository = create_respository
    repository.add(id, original_word)

    expect(repository.exists?(id)).to be true
  end

  it 'should return indicate that an answer does not exist' do
    repository = create_respository

    expect(repository.exists?(non_existant_id)).to be false
  end

  private

  def create_respository
    Persistence::AnswerRepository.new
  end
end
