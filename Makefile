ifneq (,)
.error This Makefile requires GNU Make.
endif

.PHONY: help start stop logs reset enter

help:
	@echo "start       Start docker-compose"
	@echo "stop        Stop docker-compose"
	@echo "logs        View web server access/error logs"
	@echo "reset       Stop container, remove their state and the remove Docker volume"
	@echo "enter       Enter the web server container"

start:
	docker-compose up -d

stop:
	docker-compose stop

logs:
	docker-compose logs -f dvwa_web

reset:
	docker-compose kill 2> /dev/null || true
	docker-compose rm -f 2>/dev/null || true
	docker volume rm $(shell basename $(CURDIR))_dvwa_db_data 2> /dev/null || true
	@echo "Reset complete"

enter:
	docker-compose exec -w /var/www/html dvwa_web bash
