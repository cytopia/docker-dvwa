#!/bin/sh
set -e
set -u


###
### Sane defaults
###
DEF_RECAPTCHA_PRIV_KEY=""
DEF_RECAPTCHA_PUB_KEY=""
DEF_SECURITY_LEVEL="medium"
DEF_PHP_DISPLAY_ERRORS="0"
DEF_PHPIDS_ENABLED="disabled"
DEF_PHPIDS_VERBOSE="false"


###
### Check for required env variables
###
if ! env | grep '^MYSQL_HOSTNAME=' >/dev/null; then
	>&2 printf "[ERROR] MYSQL_HOSTNAME env variable is not set, but required\\n"
	exit 1
fi
if ! env | grep '^MYSQL_DATABASE=' >/dev/null; then
	>&2 printf "[ERROR] MYSQL_DATABASE env variable is not set, but required\\n"
	exit 1
fi
if ! env | grep '^MYSQL_USERNAME=' >/dev/null; then
	>&2 printf "[ERROR] MYSQL_USERNAME env variable is not set, but required\\n"
	exit 1
fi
if ! env | grep '^MYSQL_PASSWORD=' >/dev/null; then
	>&2 printf "[ERROR] MYSQL_PASSWORD env variable is not set, but required\\n"
	exit 1
fi


###
### Summon env variables
###
if env | grep '^RECAPTCHA_PRIV_KEY=' >/dev/null; then
	DEF_RECAPTCHA_PRIV_KEY="${RECAPTCHA_PRIV_KEY}"
fi
if env | grep '^RECAPTCHA_PUB_KEY=' >/dev/null; then
	DEF_RECAPTCHA_PUB_KEY="${RECAPTCHA_PUB_KEY}"
fi
if env | grep '^SECURITY_LEVEL=' >/dev/null; then
	DEF_SECURITY_LEVEL="${SECURITY_LEVEL}"
fi
if env | grep '^PHP_DISPLAY_ERRORS=' >/dev/null; then
	DEF_PHP_DISPLAY_ERRORS="${PHP_DISPLAY_ERRORS}"
fi
if env | grep '^PHPIDS_ENABLED=' >/dev/null; then
	DEF_PHPIDS_ENABLED="${PHPIDS_ENABLED}"
	if [ "${PHPIDS_ENABLED}" = "0" ]; then
		DEF_PHPIDS_ENABLED="disabled"
	fi
	if [ "${PHPIDS_ENABLED}" = "1" ]; then
		DEF_PHPIDS_ENABLED="enabled"
	fi
fi
if env | grep '^PHPIDS_VERBOSE=' >/dev/null; then
	if [ "${PHPIDS_VERBOSE}" = "0" ]; then
		DEF_PHPIDS_VERBOSE="false"
	fi
	if [ "${PHPIDS_VERBOSE}" = "1" ]; then
		DEF_PHPIDS_VERBOSE="true"
	fi
fi


###
### Print settings
###
>&2 printf "Setting PHP version:        %s\\n" "$(php -v | grep ^PHP | head -1)"

>&2 printf "Setting MySQL hostname:     %s\\n" "${MYSQL_HOSTNAME}"
>&2 printf "Setting MySQL database:     %s\\n" "${MYSQL_DATABASE}"
>&2 printf "Setting MySQL username:     %s\\n" "${MYSQL_USERNAME}"
>&2 printf "Setting MySQL password:     %s\\n" "$( echo "${MYSQL_PASSWORD}" | sed 's/./*/g' )"

>&2 printf "Setting Recaptcha priv key: %s\\n" "$( echo "${DEF_RECAPTCHA_PRIV_KEY}" | sed 's/./*/g' )"
>&2 printf "Setting Recaptcha pub key:  %s\\n" "$( echo "${DEF_RECAPTCHA_PUB_KEY}" | sed 's/./*/g' )"
>&2 printf "Setting Security level:     %s\\n" "${DEF_SECURITY_LEVEL}"
>&2 printf "Setting PHP error display:  %s\\n" "${DEF_PHP_DISPLAY_ERRORS}"
>&2 printf "Setting PHP IDS state:      %s\\n" "${DEF_PHPIDS_ENABLED}"
>&2 printf "Setting PHP IDS verbosity:  %s\\n" "${DEF_PHPIDS_VERBOSE}"


###
### Adjust settings
###
{
	echo "<?php";
	echo "\$_DVWA[ 'db_server' ]   = '${MYSQL_HOSTNAME}';";
	echo "\$_DVWA[ 'db_database' ] = '${MYSQL_DATABASE}';";
	echo "\$_DVWA[ 'db_user' ]     = '${MYSQL_USERNAME}';";
	echo "\$_DVWA[ 'db_password' ] = '${MYSQL_PASSWORD}';";

	echo "\$_DVWA[ 'recaptcha_public_key' ]  = '${DEF_RECAPTCHA_PUB_KEY}';";
	echo "\$_DVWA[ 'recaptcha_private_key' ] = '${DEF_RECAPTCHA_PRIV_KEY}';";
	echo "\$_DVWA[ 'default_security_level' ] = '${DEF_SECURITY_LEVEL}';";
	echo "\$_DVWA[ 'default_phpids_level' ] = '${DEF_PHPIDS_ENABLED}';";
	echo "\$_DVWA[ 'default_phpids_verbose' ] = '${DEF_PHPIDS_VERBOSE}';";

	echo "define (\"MYSQL\", \"mysql\");";
	echo "define (\"SQLITE\", \"sqlite\");";
	# TODO: make this configurable via docker env vars
	echo "\$_DVWA[\"SQLI_DB\"]    = MYSQL;";
	echo "#\$_DVWA[\"SQLI_DB\"]   = SQLITE;";
	echo "#\$_DVWA[\"SQLITE_DB\"] = \"sqli.db\";";
	echo "?>";
} >> /var/www/html/config/config.inc.php

if [ "${DEF_PHP_DISPLAY_ERRORS}" = "1" ]; then
	echo "display_errors = on" > /usr/local/etc/php/conf.d/errors.ini
else
	echo "display_errors = off" > /usr/local/etc/php/conf.d/errors.ini
fi


###
### Normal start
###
exec apache2-foreground
