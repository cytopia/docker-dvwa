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
	>&2 echo  "Setting Recaptcha private key."
	DEF_RECAPTCHA_PRIV_KEY="${RECAPTCHA_PRIV_KEY}"
fi
if env | grep '^RECAPTCHA_PUB_KEY=' >/dev/null; then
	>&2 echo  "Setting Recaptcha public key."
	DEF_RECAPTCHA_PUB_KEY="${RECAPTCHA_PUB_KEY}"
fi
if env | grep '^SECURITY_LEVEL=' >/dev/null; then
	>&2 echo  "Setting Security level."
	DEF_SECURITY_LEVEL="${SECURITY_LEVEL}"
fi
if env | grep '^PHP_DISPLAY_ERRORS=' >/dev/null; then
	>&2 echo  "Setting PHP error display."
	DEF_PHP_DISPLAY_ERRORS="${PHP_DISPLAY_ERRORS}"
fi
if env | grep '^PHPIDS_ENABLED=' >/dev/null; then
	>&2 echo  "Setting PHP IDS enabled/disabled."
	DEF_PHPIDS_ENABLED="${PHPIDS_ENABLED}"
	if [ "${PHPIDS_ENABLED}" = "0" ]; then
		DEF_PHPIDS_ENABLED="disabled"
	fi
	if [ "${PHPIDS_ENABLED}" = "1" ]; then
		DEF_PHPIDS_ENABLED="enabled"
	fi
fi
if env | grep '^PHPIDS_VERBOSE=' >/dev/null; then
	>&2 echo  "Setting PHP IDS verbosity."
	if [ "${PHPIDS_VERBOSE}" = "0" ]; then
		DEF_PHPIDS_VERBOSE="false"
	fi
	if [ "${PHPIDS_VERBOSE}" = "1" ]; then
		DEF_PHPIDS_VERBOSE="true"
	fi
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
