ifneq (,)
.error This Makefile requires GNU Make.
endif

.PHONY: help start stop logs reset enter update


# --------------------------------------------------------------------------------------------------
# Variables
# --------------------------------------------------------------------------------------------------
DIR = docker
IMAGE = cytopia/dvwa
TAG = latest
PHP = 7.2
NO_CACHE =

# --------------------------------------------------------------------------------------------------
# Default Target
# --------------------------------------------------------------------------------------------------
help:
	@echo "start       Start docker-compose"
	@echo "stop        Stop docker-compose"
	@echo "logs        View web server access/error logs"
	@echo "reset       Stop container, remove their state and the remove Docker volume"
	@echo "enter       Enter the web server container"
	@echo "update      Pull latest Docker images"

# --------------------------------------------------------------------------------------------------
# User Targets
# --------------------------------------------------------------------------------------------------
start: .env
	@echo "Starting DVWA"
	docker-compose up -d
	docker-compose logs dvwa_web 2>&1 | grep "Setting"

stop:
	@echo "Stopping DVWA"
	docker-compose down

logs:
	docker-compose logs -f dvwa_web

reset:
	@echo "Resetting DVWA and removing MySQL volumes"
	docker-compose kill 2> /dev/null || true
	docker-compose rm -f 2>/dev/null || true
	docker volume rm $(shell basename $(CURDIR))_dvwa_db_data 2> /dev/null || true
	@echo "Reset complete"

enter:
	docker-compose exec -w /var/www/html dvwa_web bash


update: _update_web
update: _update_db

_update_web:
	docker-compose pull dvwa_web

_update_db:
	docker-compose pull dvwa_db

# Copy .env from .env-example if it does not exist
.env:
	cp .env-example .env



# --------------------------------------------------------------------------------------------------
# CI Targets
# --------------------------------------------------------------------------------------------------

build:
	docker build $(NO_CACHE) --build-arg PHP_VERSION=$(PHP) -t $(IMAGE) -f $(DIR)/Dockerfile $(DIR)

rebuild: NO_CACHE=--no-cache
rebuild: build


test:
	@echo "Testing for login page to become available"
	@SUCCESS=0; \
	for in in $$(seq 60); do \
		printf "."; \
		if [ "$$(curl -sS -o /dev/null -w '%{http_code}' http://localhost:8000/login.php)" = "200" ]; then \
			SUCCESS=1; \
			break; \
		fi; \
		sleep 1; \
	done; \
	if [ "$${SUCCESS}" != "1" ]; then \
		printf "\\nFAILED\\n"; \
		exit 1; \
	else \
		printf "\\nSUCCESS\\n"; \
	fi

.PHONY: tag
tag:
	docker tag $(IMAGE) $(IMAGE):$(TAG)

.PHONY: login
login:
	yes | docker login --username $(USER) --password $(PASS)

.PHONY: push
push:
	docker push $(IMAGE):$(TAG)
