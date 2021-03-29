PROJECT="word-scramble"

install:
		bundle install
build:
		docker build --no-cache -t ${PROJECT} .

start: build
		docker run -d -p 9090:9090 ${PROJECT}

start_development: install
		rake start

test: install
		rake

lint:
		rubocop -a app spec
