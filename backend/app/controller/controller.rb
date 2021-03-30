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

get '/health' do
end

get '/question' do
  content_type 'application/json'
  JSON.generate(service.ask_question)
end

post '/question/:id' do
  content_type 'application/json'

  body = request.body.read
  return 400 if answer_invalid?(body)

  data = JSON.parse(body)
  return 404 unless service.question_exists?(params['id'])

  result = service.answer_question(params['id'], data['answer'])
  JSON.generate(result)
end

delete '/question/:id' do
  content_type 'application/json'

  return 404 unless service.question_exists?(params['id'])

  result = service.skip_question(params['id'])
  JSON.generate(result)
end

private

def answer_invalid?(body)
  body.empty? || body['answer'].nil?
end
