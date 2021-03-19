ifneq (,)
.error This Makefile requires GNU Make.
endif

.PHONY: help start stop logs reset enter

help:
	@echo "start       Start docker-compose"
	@echo "stop        Stop docker-compose"
	@echo "logs        View web server access/error logs"
	@echo "build       Build the DVWA Docker image"
	@echo "rebuild     Rebuild the DVWA Docker image (ignoring cache)"
	@echo "reset       Stop container, remove their state and the remove Docker volume"
	@echo "enter       Enter the web server container"

start: .env
	@echo "Starting DVWA"
	docker-compose up -d
	docker-compose logs dvwa_web 2>&1 | grep "Setting"

stop:
	@echo "Stopping DVWA"
	docker-compose stop

logs:
	docker-compose logs -f dvwa_web

reset:
	@echo "Resetting DVWA and removing MySQL volumes"
	docker-compose kill 2> /dev/null || true
	docker-compose rm -f 2>/dev/null || true
	docker volume rm $(shell basename $(CURDIR))_dvwa_db_data 2> /dev/null || true
	@echo "Reset complete"

build:
	docker-compose build

rebuild:
	docker-compose build --no-cache

enter:
	docker-compose exec -w /var/www/html dvwa_web bash

# Copy .env from .env-example if it does not exist
.env:
	cp .env-example .env
