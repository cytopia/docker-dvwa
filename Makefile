

IMAGE = cytopia/dvwa

build: init
	docker build -t $(IMAGE) .

run:
	docker run -it --rm -p 8080:80 $(IMAGE)

enter:
	docker run -it --rm $(IMAGE) bash


init:
	git submodule update --init --recursive
