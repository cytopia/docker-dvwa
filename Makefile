ifneq (,)
.error This Makefile requires GNU Make.
endif

.PHONY: help start stop enter

help:
	@echo "start       Start docker-compose"
	@echo "stop        Stop docker-compose"
	@echo "enter       Enter the web server container"

start:
	docker-compose up -d

stop:
	docker-compose stop

enter:
	docker-compose exec -w /var/www/html dvwa_web bash
