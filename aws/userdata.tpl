#!/usr/bin/env bash

set -eux
set -o pipefail

# --------------------------------------------------------------------------------------------------
# GLOBALS
# --------------------------------------------------------------------------------------------------
RETRIES=20


# --------------------------------------------------------------------------------------------------
# FUNCTIONS
# --------------------------------------------------------------------------------------------------
retry() {
	for n in $(seq $${RETRIES}); do
		echo "[$${n}/$${RETRIES}] $${*}";
		if eval "$${*}"; then
			echo "[SUCC] $${n}/$${RETRIES}";
			return 0;
		fi;
		sleep 2;
		echo "[FAIL] $${n}/$${RETRIES}";
	done;
	return 1;
}


# --------------------------------------------------------------------------------------------------
# ENTRYPOINT
# --------------------------------------------------------------------------------------------------

###
### Installation
###

# Install Docker
curl -fsSL https://get.docker.com | sh

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install git
apt update;
apt install -y git;

# Install docker-dvwa
git clone https://github.com/cytopia/docker-dvwa /tmp/docker-dvwa


###
### Configuration
###

# Setup dvwa
cd /tmp/docker-dvwa
cp .env-example .env
echo "PHP_VERSION=${php_version}" >> .env
echo "LISTEN_PORT=${listen_port}" >> .env


###
### Run
###

docker-compose up -d
