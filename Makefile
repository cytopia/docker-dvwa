ifneq (,)
.error This Makefile requires GNU Make.
endif

.PHONY: start stop init

start: init
	docker-compose up -d

stop:
	docker-compose stop

init:
	git submodule update --init --recursive
