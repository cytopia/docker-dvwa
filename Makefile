ifneq (,)
.error This Makefile requires GNU Make.
endif

.PHONY: start stop

start:
	docker-compose up -d

stop:
	docker-compose stop
