#!/bin/sh
DEF_RECAPTCHA_PRIV_KEY=""
DEF_RECAPTCHA_PUB_KEY=""
DEF_SECURITY_LEVEL="medium"
DEF_PHP_DISPLAY_ERRORS="0"
DEF_PHPIDS_ENABLED="disabled"
DEF_PHPIDS_VERBOSE="false"


###
### Summon env variables
###
if env | grep '^RECAPTCHA_PRIV_KEY=' >/dev/null; then
	>&2 printf "Setting Recaptcha priv key: %s\\n" "$( echo "${RECAPTCHA_PRIV_KEY}" | sed 's/./*/g' )"
	DEF_RECAPTCHA_PRIV_KEY="${RECAPTCHA_PRIV_KEY}"
fi
if env | grep '^RECAPTCHA_PUB_KEY=' >/dev/null; then
	>&2 printf "Setting Recaptcha pub key:  %s\\n" "$( echo "${RECAPTCHA_PUB_KEY}" | sed 's/./*/g' )"
	DEF_RECAPTCHA_PUB_KEY="${RECAPTCHA_PUB_KEY}"
fi
if env | grep '^SECURITY_LEVEL=' >/dev/null; then
	>&2 printf "Setting Security level:     %s\\n" "${SECURITY_LEVEL}"
	DEF_SECURITY_LEVEL="${SECURITY_LEVEL}"
fi
if env | grep '^PHP_DISPLAY_ERRORS=' >/dev/null; then
	>&2 printf "Setting PHP error display:  %s\\n" "${PHP_DISPLAY_ERRORS}"
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
	>&2 printf "Setting PHP IDS state:      %s\\n" "${DEF_PHPIDS_ENABLED}"

fi
if env | grep '^PHPIDS_VERBOSE=' >/dev/null; then
	if [ "${PHPIDS_VERBOSE}" = "0" ]; then
		DEF_PHPIDS_VERBOSE="false"
	fi
	if [ "${PHPIDS_VERBOSE}" = "1" ]; then
		DEF_PHPIDS_VERBOSE="true"
	fi
	>&2 printf "Setting PHP IDS verbosity:  %s\\n" "${DEF_PHPIDS_VERBOSE}"
fi


###
### Adjust settings
###

{
	echo "<?php";
	echo "\$_DVWA[ 'recaptcha_public_key' ]  = '${DEF_RECAPTCHA_PUB_KEY}';";
	echo "\$_DVWA[ 'recaptcha_private_key' ] = '${DEF_RECAPTCHA_PRIV_KEY}';";
	echo "\$_DVWA[ 'default_security_level' ] = '${DEF_SECURITY_LEVEL}';";
	echo "\$_DVWA[ 'default_phpids_level' ] = '${DEF_PHPIDS_ENABLED}';";
	echo "\$_DVWA[ 'default_phpids_verbose' ] = '${DEF_PHPIDS_VERBOSE}';";
	echo "?>";
} >> /var/www/html/config/config.inc.php

if [ "${DEF_PHP_DISPLAY_ERRORS}" = "1" ]; then
	echo "display_errors = on" > /usr/local/etc/php/conf.d/errors.ini
else
	echo "display_errors = off" > /usr/local/etc/php/conf.d/errors.ini
fi



# Normal start
exec apache2-foreground
