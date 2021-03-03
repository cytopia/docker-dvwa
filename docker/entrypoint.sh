#!/bin/sh
DEF_RECAPTCHA_PRIV_KEY=""
DEF_RECAPTCHA_PUB_KEY=""
DEF_SECURITY_LEVEL="medium"
DEF_PHP_DISPLAY_ERRORS="0"


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


{
	echo "<?php";
	echo "\$_DVWA[ 'recaptcha_public_key' ]  = '${DEF_RECAPTCHA_PUB_KEY}';";
	echo "\$_DVWA[ 'recaptcha_private_key' ] = '${DEF_RECAPTCHA_PRIV_KEY}';";
	echo "\$_DVWA[ 'default_security_level' ] = '${DEF_SECURITY_LEVEL}';";
	echo "?>";
} >> /var/www/html/config/config.inc.php

if [ "${DEF_PHP_DISPLAY_ERRORS}" = "1" ]; then
	echo "display_errors = on" > /usr/local/etc/php/conf.d/errors.ini
else
	echo "display_errors = off" > /usr/local/etc/php/conf.d/errors.ini
fi

# Normal start
apache2-foreground
