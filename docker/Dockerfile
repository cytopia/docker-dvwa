FROM php:7.2-apache as builder

RUN set -eux \
	&& apt update \
	&& apt install -y git \
	&& git clone https://github.com/digininja/DVWA /DVWA \
	&& rm -rf /DVWA/.git \
	&& rm -rf /DVWA/.github \
	&& rm -rf /DVWA/.gitignore


FROM php:7.2-apache

# Satisfy PHP requirements
RUN set -eux \
	&& apt update \
	&& apt install -y \
		libpng-dev \
	&& docker-php-ext-install gd \
	&& docker-php-ext-install mysqli \
	&& docker-php-ext-install pdo_mysql

# Satisfy Application requirements
RUN set -eux \
	&& apt update \
	&& apt install -y \
		iputils-ping

# Copy source
COPY --from=builder /DVWA/ /var/www/html/
COPY ./config.inc.php /var/www/html/config/config.inc.php
COPY ./entrypoint.sh/ /entrypoint.sh

# Configure PHP
RUN set -eux \
	&& { \
		echo "allow_url_include = on"; \
		echo "allow_url_fopen   = on"; \
	} > /usr/local/etc/php/conf.d/default.ini

# Adjust permissions
RUN set -eux \
	&& chown -R www-data:www-data /var/www/html \
	&& chmod 0775 /var/www/html/config/ \
	&& chmod 0775 /var/www/html/hackable/uploads/ \
	&& chmod 0775 /var/www/html/external/phpids/0.6/lib/IDS/tmp/ \
	&& chmod 0664 /var/www/html/external/phpids/0.6/lib/IDS/tmp/phpids_log.txt

CMD ["/entrypoint.sh"]
