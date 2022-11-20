ifneq (,)
.error This Makefile requires GNU Make.
endif

# Ensure additional Makefiles are present
MAKEFILES = Makefile.docker Makefile.lint
$(MAKEFILES): URL=https://raw.githubusercontent.com/devilbox/makefiles/master/$(@)
$(MAKEFILES):
	@if ! (curl --fail -sS -o $(@) $(URL) || wget -O $(@) $(URL)); then \
		echo "Error, curl or wget required."; \
		echo "Exiting."; \
		false; \
	fi
include $(MAKEFILES)

# Set default Target
.DEFAULT_GOAL := help


# -------------------------------------------------------------------------------------------------
# Default configuration
# -------------------------------------------------------------------------------------------------
TAG        = latest
PHP_LATEST = 8.1

NAME       = dvwa
IMAGE      = cytopia/dvwa
VERSION    = latest
DIR        = docker
FILE       = Dockerfile


# Building from master branch: Tag == 'latest'
ifeq ($(strip $(TAG)),latest)
	ifeq ($(strip $(VERSION)),latest)
		PHP        = $(PHP_LATEST)
		DOCKER_TAG = latest
	else
		PHP        = $(VERSION)
		DOCKER_TAG = php-$(VERSION)
	endif
# Building from any other branch or tag: Tag == '<REF>'
else
	ifeq ($(strip $(VERSION)),latest)
		PHP        = $(PHP_LATEST)
		DOCKER_TAG = latest-$(TAG)
	else
		PHP        = $(VERSION)
		DOCKER_TAG = php-$(VERSION)-$(TAG)
	endif
endif

DOCKER_PULL_VARIABLES = "VERSION=$(PHP)"

# --------------------------------------------------------------------------------------------------
# Default Target
# --------------------------------------------------------------------------------------------------
.PHONY: help
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
.PHONY: start
start: .env
	@echo "Starting DVWA"
	docker-compose up -d
	docker-compose logs dvwa_web 2>&1 | grep "Setting"

.PHONY: stop
stop:
	@echo "Stopping DVWA"
	docker-compose down

.PHONY: logs
logs:
	docker-compose logs -f dvwa_web

.PHONY: reset
reset:
	@echo "Resetting DVWA and removing MySQL volumes"
	docker-compose kill 2> /dev/null || true
	docker-compose rm -f 2>/dev/null || true
	docker volume rm $(shell basename $(CURDIR))_dvwa_db_data 2> /dev/null || true
	@echo "Reset complete"

.PHONY: enter
enter:
	docker-compose exec -w /var/www/html dvwa_web bash

.PHONY: update
update: _update_web
update: _update_db

.PHONY: _update_web
_update_web:
	docker-compose pull dvwa_web

.PHONY: _update_db
_update_db:
	docker-compose pull dvwa_db

# Copy .env from .env-example if it does not exist (NO .PHONY)
.env:
	cp .env-example .env


# -------------------------------------------------------------------------------------------------
#  Docker Targets
# -------------------------------------------------------------------------------------------------
.PHONY: build
build: ARGS+=--build-arg VERSION=$(PHP)
build: docker-arch-build

.PHONY: rebuild
rebuild: ARGS+=--build-arg VERSION=$(PHP)
rebuild: docker-arch-rebuild

.PHONY: push
push: docker-arch-push


# -------------------------------------------------------------------------------------------------
#  Manifest Targets
# -------------------------------------------------------------------------------------------------
.PHONY: manifest-create
manifest-create: docker-manifest-create

.PHONY: manifest-push
manifest-push: docker-manifest-push


# -------------------------------------------------------------------------------------------------
# Test Targets
# -------------------------------------------------------------------------------------------------
.PHONY: test
test: _test-configure
test: _test-start
test: _test-available
test: _test-ready
test: _test-stop

.PHONY: _test-configure
_test-configure:
	@echo "#---------------------------------------------------------------------------------#"
	@echo "# [TESTING] Configure DVWA"
	@echo "#---------------------------------------------------------------------------------#"
	mkdir -p tests/
	cp -f .env-example tests/.env
	cp -f docker-compose.yml tests/
	sed -i'' "s|image: cytopia.*|image: $(IMAGE):$(DOCKER_TAG)|g" tests/docker-compose.yml
	echo "PHP_VERSION=${VERSION}" >> tests/.env
	@echo

.PHONY: _test-start
_test-start:
	@echo "#---------------------------------------------------------------------------------#"
	@echo "# [TESTING] Start DVWA"
	@echo "#---------------------------------------------------------------------------------#"
	cd tests && docker-compose up -d
	cd tests && docker-compose logs dvwa_web 2>&1 | grep "Setting"
	@echo

.PHONY: _test-stop
_test-stop:
	@echo "#---------------------------------------------------------------------------------#"
	@echo "# Stop DVWA"
	@echo "#---------------------------------------------------------------------------------#"
	cd tests && docker-compose down
	cd tests && docker-compose rm -f
	@echo

.PHONY: _test-available
_test-available:
	@echo "#---------------------------------------------------------------------------------#"
	@echo "# [TESTING] Check login: avail"
	@echo "#---------------------------------------------------------------------------------#"
	@echo "Waiting for login page to become available"
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
		cd tests && docker-compose logs; \
		printf "\\nFAILED\\n"; \
		exit 1; \
	else \
		printf "\\nSUCCESS\\n"; \
	fi
	@echo

.PHONY: _test-ready
_test-ready:
	@echo "#---------------------------------------------------------------------------------#"
	@echo "# [TESTING] Check login: ready"
	@echo "#---------------------------------------------------------------------------------#"
	@echo "Testing for login page to become ready"
	@for in in $$(seq 60); do \
		SUCCESS=0; \
		printf "."; \
		if ! curl -sS http://localhost:8000/login.php | grep -E 'Unable to connect|Cannot modify header|Undefined variable|Warning:|Notice:' >/dev/null; then \
			SUCCESS=1; \
		fi; \
		if curl -sS http://localhost:8000/login.php | grep -E 'Damn Vulnerable Web Application' >/dev/null; then \
			SUCCESS=$$(( SUCCESS + 1 )); \
		fi; \
		if [ "$${SUCCESS}" = "2" ]; then \
			break; \
		fi; \
		sleep 1; \
	done; \
	if [ "$${SUCCESS}" != "2" ]; then \
		cd tests && docker-compose logs; \
		printf "\\nFAILED\\n"; \
		exit 1; \
	else \
		printf "\\nSUCCESS\\n"; \
	fi
	@echo
