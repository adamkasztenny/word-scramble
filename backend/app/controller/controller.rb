# frozen_string_literal: true

require 'sinatra'
require_relative '../persistence/word_repository'
require_relative '../persistence/answer_repository'
require_relative '../domain/word_scrambler'
require_relative '../service/game_service'

service = Service::GameService.new(
  Persistence::WordRepository.new,
  Domain::WordScrambler,
  Persistence::AnswerRepository.new
)

get '/question' do
  content_type 'application/json'
  JSON.generate(service.ask_question)
end

post '/answer' do
  content_type 'application/json'

  body = request.body.read
  return 400 if answer_invalid?(body)

  data = JSON.parse(body)
  return 404 unless service.question_exists?(data['id'])

  result = service.answer_question(data['id'], data['answer'])
  JSON.generate(result)
end

post '/skip' do
  content_type 'application/json'

  body = request.body.read
  return 400 if skip_invalid?(body)

  data = JSON.parse(body)
  return 404 unless service.question_exists?(data['id'])

  result = service.skip_question(data['id'])

  JSON.generate(result)
end

private

def answer_invalid?(body)
  body.empty? || body['id'].nil? || body['answer'].nil?
end

def skip_invalid?(body)
  body.empty? || body['id'].nil?
end
