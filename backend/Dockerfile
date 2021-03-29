FROM ruby:3.0.0-alpine3.13

COPY . .

RUN apk add --no-cache build-base git

RUN bundle config set --local without 'development test'
RUN bundle install

ENV APP_ENV=production

RUN addgroup -S word-scramble && adduser -S word-scramble -G word-scramble
USER word-scramble

EXPOSE 9090
ENTRYPOINT ["rake", "start"]

