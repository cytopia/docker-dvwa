# Dockerized [DVWA](https://github.com/digininja/DVWA)


Docker Compose setup of [DVWA](https://github.com/digininja/DVWA)


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
| `SECURITY_LEVEL`     | Adjust the difficulty of the challenges |
| `PHP_DISPLAY_ERRORS` | Show PHP errors on the website (if you want a really easy mode |





## :page_facing_up: License

**[MIT License](LICENSE.md)**

Copyright (c) 2021 **[cytopia](https://github.com/cytopia)**
