FROM php:7.2-apache

# Satisfy requirements
RUN set -eux \
	&& apt update \
	&& apt install -y \
		libpng-dev \
	&& docker-php-ext-install gd \
	&& docker-php-ext-install mysqli \
	&& docker-php-ext-install pdo_mysql

# Copy source
COPY ./DVWA/ /var/www/html/

# Adjust permissions
RUN set -eux \
	&& chmod 0777 /var/www/html/config/ \
	&& chmod 0777 /var/www/html/hackable/uploads/ \
	&& chmod 0666 /var/www/html/external/phpids/0.6/lib/IDS/tmp/phpids_log.txt
