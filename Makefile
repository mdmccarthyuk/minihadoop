build:
	docker build -t minihadoop .

run:
	docker run -d --name minihadoop --rm -p 9000:9000 -p 8088:8088 -p 50020:50020 -p 50070:50070 -p 50010:50010 minihadoop

up:	build run

stop:
	docker kill minihadoop;

