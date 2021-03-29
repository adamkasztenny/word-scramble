build:
	wget https://github.com/first20hours/google-10000-english/blob/master/google-10000-english-no-swears.txt
	mv google-10000-english-no-swears.txt backend/app/google-10000-english-no-swears.txt
	docker-compose build --no-cache

start:
	docker-compose up -d --force-recreate --build
	
test:
	$(MAKE) -C frontend test
	$(MAKE) -C backend test
