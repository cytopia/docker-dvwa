ifneq (,)
.error This Makefile requires GNU Make.
endif

.PHONY: help start stop reset enter

help:
	@echo "start       Start docker-compose"
	@echo "stop        Stop docker-compose"
	@echo "reset       Stop container, remove their state and the remove Docker volume"
	@echo "enter       Enter the web server container"

start:
	docker-compose up -d

stop:
	docker-compose stop

reset:
	docker-compose kill 2> /dev/null || true
	docker-compose rm -f 2>/dev/null || true
	docker volume rm $(shell basename $(CURDIR))_dvwa_db_data 2> /dev/null || true
	@echo "Reset complete"

enter:
	docker-compose exec -w /var/www/html dvwa_web bash
