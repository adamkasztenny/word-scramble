# frozen_string_literal: true

require_relative '../../../app/controller/controller'
require 'json'
require 'uuid'

RSpec.describe 'Word Scramble Game API' do
  context 'Generating a scrambled word question' do
    it 'should return a question as JSON' do
      visit '/question'

      expect(last_response.status).to eq(200)
      content_type = last_response.headers['Content-Type']
      expect(content_type).to eq('application/json')

      body_as_json = JSON.parse(response_body)
      expect(body_as_json).not_to be_empty
    end

    it 'should return a randomly scrambled word with an ID' do
      visit '/question'

      expect(last_response.status).to eq(200)
      body_as_json = JSON.parse(response_body)
      scrambled_word = body_as_json['scrambled_word']
      id = body_as_json['id']

      expect(scrambled_word.size).to be > 2
      UUID.validate(id)
    end
  end

  context 'Answering a scrambled word question' do
    it 'should return whether the answer is correct as JSON' do
      visit '/question'
      body_as_json = JSON.parse(response_body)
      id = body_as_json['id']

      answer_body = {  answer: 'some answer' }
      post('/question/' + id, answer_body.to_json)

      expect(last_response.status).to eq(200)
      content_type = last_response.headers['Content-Type']
      expect(content_type).to eq('application/json')

      body_as_json = JSON.parse(response_body)
      expect(body_as_json).not_to be_empty
    end

    it 'should indicate the answer is incorrect and include no points' do
      visit '/question'

      question_as_json = JSON.parse(response_body)
      id = question_as_json['id']
      answer_body = { answer: 'clearly wrong' }

      post('/question/' + id, answer_body.to_json)
      expect(last_response.status).to eq(200)

      answer_response_as_json = JSON.parse(response_body)
      expect(answer_response_as_json['correct']).to be false
      expect(answer_response_as_json['points']).to be 0
    end

    it 'should indicate the answer is correct and include the points gained' do
      visit '/question'

      question_as_json = JSON.parse(response_body)
      scrambled_word = question_as_json['scrambled_word']
      id = question_as_json['id']

      permutations = scrambled_word.chars.permutation.map(&:join)

      solved = false
      points = 0

      permutations.each do |permutation|
        answer_body = { answer: permutation }
        post('/question/' + id, answer_body.to_json)
        expect(last_response.status).to eq(200)

        answer_response_as_json = JSON.parse(response_body)
        next unless answer_response_as_json['correct'] == true

        solved = true
        points = answer_response_as_json['points']
        break
      end

      expect(solved).to be true
      expect(points).to be > 0
    end

    it 'should indicate that the request is invalid if there is no body' do
      visit '/question', :post

      expect(last_response.status).to eq(404)
    end

    it 'should indicate that the answer is not valid if the question id is not found' do
      answer_body = { answer: 'irrelevant' }
      post('/question/nonexistent', answer_body.to_json)

      expect(last_response.status).to eq(404)
    end

    it 'should indicate that the request is invalid if the id is missing' do
      answer_body = { answer: 'irrelevant' }
      post('/question', answer_body.to_json)

      expect(last_response.status).to eq(404)
    end

    it 'should indicate that the request is invalid if the answer is missing' do
      wrong_body_format = {}
      post('/question/123', wrong_body_format.to_json)

      expect(last_response.status).to eq(400)
    end

    it 'should indicate that the request is invalid if the request JSON is invalid' do
      wrong_body_format = { :garbo => 'true', 'derp' => 'yes' }
      post('/question/123', wrong_body_format.to_json)

      expect(last_response.status).to eq(400)
    end
  end

  context 'Skipping a scrambled word question' do
    it 'should return JSON' do
      visit '/question'

      question_as_json = JSON.parse(response_body)
      id = question_as_json['id']

      skip_body = { id: id }
      post('/skip', skip_body.to_json)

      expect(last_response.status).to eq(200)
      content_type = last_response.headers['Content-Type']
      expect(content_type).to eq('application/json')

      body_as_json = JSON.parse(response_body)
      expect(body_as_json).not_to be_empty
    end

    it 'should remove the question' do
      visit '/question'

      question_as_json = JSON.parse(response_body)
      id = question_as_json['id']

      skip_body = { id: id }
      post('/skip', skip_body.to_json)

      expect(last_response.status).to eq(200)

      answer_body = { id: id, answer: 'irrelevant' }
      post('/answer', answer_body.to_json)

      expect(last_response.status).to eq(404)
    end

    it 'should return the points lost' do
      visit '/question'

      question_as_json = JSON.parse(response_body)
      id = question_as_json['id']

      skip_body = { id: id }
      post('/skip', skip_body.to_json)

      expect(last_response.status).to eq(200)
      body_as_json = JSON.parse(response_body)

      expect(body_as_json['points']).to be < 0
    end

    it 'should indicate that the request is invalid if there is no body' do
      visit '/skip', :post

      expect(last_response.status).to eq(400)
    end

    it 'should indicate that the skip request is not valid if the question id is not found' do
      skip_body = { id: 'non-existant-id', answer: 'irrelevant' }
      post('/skip', skip_body.to_json)

      expect(last_response.status).to eq(404)
    end

    it 'should indicate that the request is invalid if the id is missing' do
      wrong_body_format = { derp: 'true' }
      post('/skip', wrong_body_format.to_json)

      expect(last_response.status).to eq(400)
    end
  end
end
