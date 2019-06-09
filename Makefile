build:
	docker build -t minihadoop .

run:
	docker run -d --name minihadoop --rm -p 9000:9000 -p 8088:8088 -p 50020:50020 -p 50070:50070 -p 50010:50010 -p 10000:10000 -p 8042:8042 -p 8032:8032  minihadoop

up:	build run

stop:
	docker kill minihadoop;

