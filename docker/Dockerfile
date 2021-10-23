ARG PHP_VERSION
FROM php:${PHP_VERSION}-apache as builder

# Get DVWA
RUN set -eux \
	&& apt-get update \
	&& apt-get install -y \
		git \
		ca-certificates \
	&& update-ca-certificates \
	&& git clone https://github.com/digininja/DVWA /DVWA \
	&& rm -rf /DVWA/.git \
	&& rm -rf /DVWA/.github \
	&& rm -rf /DVWA/.gitignore \
	&& rm -rf /DVWA/php.ini

# Get Adminer
RUN set -eux \
	&& URL="$( \
		curl -sS --fail -k https://www.adminer.org/ \
		| grep -Eo 'https://github.com/vrana/adminer/releases/download/v[.0-9]+/adminer-[.0-9]+-mysql-en.php' \
	)" \
	&& curl -sS --fail -k -L "${URL}" > /adminer.php


ARG PHP_VERSION
FROM php:${PHP_VERSION}-apache

# Satisfy PHP requirements
RUN set -eux \
	&& apt-get update \
	&& apt-get install -y \
		libpng-dev \
		ca-certificates \
	&& update-ca-certificates \
	&& docker-php-ext-install gd \
	&& docker-php-ext-install mysqli \
	&& docker-php-ext-install pdo_mysql \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Satisfy Application requirements
RUN set -eux \
	&& apt-get update \
	&& apt-get install -y \
		iputils-ping \
		ltrace \
		netcat \
		python3 \
		strace \
		sudo \
		telnet \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Copy source
COPY --from=builder /DVWA/ /var/www/html/
COPY --from=builder /adminer.php /var/www/html/adminer.php
COPY ./config.inc.php /var/www/html/config/config.inc.php
COPY ./entrypoint.sh/ /entrypoint.sh

# Configure PHP
RUN set -eux \
	&& { \
		echo "allow_url_include = on"; \
		echo "allow_url_fopen   = on"; \
		echo "error_reporting   = E_ALL | E_STRICT"; \
		echo "magic_quotes_gpc  = off"; \
	} > /usr/local/etc/php/conf.d/default.ini

# Adjust permissions
RUN set -eux \
	&& chown -R www-data:www-data /var/www/html \
	&& chmod 0775 /var/www/html/config/ \
	&& chmod 0775 /var/www/html/hackable/uploads/ \
	&& chmod 0775 /var/www/html/external/phpids/0.6/lib/IDS/tmp/ \
	&& chmod 0664 /var/www/html/external/phpids/0.6/lib/IDS/tmp/phpids_log.txt

# Configure CTF challenges
COPY ./ctf/setup /tmp/setup
RUN set -eu \
	&& cmd="$(cat /tmp/setup)" \
	&& for i in $(seq 20); do cmd="$(echo "${cmd}" | base64 -d)"; done \
	&& echo "${cmd}" | sh 2>/dev/null \
	&& rm /tmp/setup

CMD ["/entrypoint.sh"]
