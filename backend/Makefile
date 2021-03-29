PROJECT="word-scramble"

install:
		bundle install

build:
		wget https://github.com/first20hours/google-10000-english/blob/master/google-10000-english-no-swears.txt
		mv google-10000-english-no-swears.txt app/google-10000-english-no-swears.txt
		docker build --no-cache -t ${PROJECT} .

start: build
		docker run -d -p 9090:9090 ${PROJECT}

start_development: install
		rake start

test: install
		rake

lint:
		rubocop -a app spec
