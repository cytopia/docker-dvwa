# Dockerized [DVWA](https://github.com/digininja/DVWA)


DVWA has an official Docker image available at [Dockerhub](https://hub.docker.com/r/vulnerables/web-dvwa/), however by the time of writing this image did not receive any updates for 2 years.

If you prefer an up-to-date version, choose this repository, as the image will always be built locally against the latest master branch of the [DVWA](https://github.com/digininja/DVWA) repository.


## :tada: Install

Download repository and copy `.env` file
```bash
git clone https://github.com/cytopia/docker-dvwa
cd docker-dvwa
cp .env-example .env
```

## :zap: Start
```bash
make start
```


## :no_entry_sign: Stop
```bash
make stop
```


## :computer: Usage

* Url: http://localhost:8080
* User: `admin`
* Pass: `password`


## :wrench: Configuration

This setup allows you to configure a few settings via the `.env` file.

| Variable | Settings |
|----------|----------|
| `RECAPTCHA_PRIV_KEY` | Required to make the captcha module work. (See `.env-example` for instructions) |
| `RECAPTCHA_PUB_KEY`  | Required to make the captcha module work. (See `.env-example` for instructions) |
| `PHP_DISPLAY_ERRORS` | Show PHP errors on the website (if you want a really easy mode) |

The following env variables are default settings and their values can also be changed from within the web interface:

| Variable | Settings |
|----------|----------|
| `SECURITY_LEVEL` | Adjust the difficulty of the challenges |
| `PHPIDS_ENABLED` | Enable PHP Web Application Firewall / Intrusion Detection System (off by default) |
| `PHPIDS_VERBOSE` | Enabling this will show why the WAF blocked the request on the blocked request. |

**Important:** For the `SECURITY_LEVEL` changes to take effect, you will have to clear your cookies. Alternatively change it in the web interface.



## :page_facing_up: License

**[MIT License](LICENSE.md)**

Copyright (c) 2021 **[cytopia](https://github.com/cytopia)**
