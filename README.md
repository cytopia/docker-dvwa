# Dockerized [DVWA](https://github.com/digininja/DVWA)

**[Install](#tada-install)** |
**[Start](#zap-start)** |
**[Stop](#no_entry_sign-stop)** |
**[Usage](#computer-usage)** |
**[Configuration](#wrench-configuration)** |
**[FAQ](#bulb-faq)** |
**[Sec Tools](#lock-cytopia-sec-tools)** |
**[License](#page_facing_up-license)**

DVWA has an official Docker image available at [Dockerhub](https://hub.docker.com/r/vulnerables/web-dvwa/), however by the time of writing this image did not receive any updates for 2 years.

If you prefer an always up-to-date version, use the here provided Docker Compose setup. The image will always be built locally against the latest master branch of the [DVWA](https://github.com/digininja/DVWA) repository.



## :tada: Install
Clone repository from GitHub:
```bash
git clone https://github.com/cytopia/docker-dvwa
```



## :zap: Start
Inside the `docker-dvwa/` directory:
```bash
make start
```



## :no_entry_sign: Stop
Inside the `docker-dvwa/` directory:
```bash
make stop
```



## :computer: Usage

After running `make start` you can access DVWA in your browser via:

* Url: http://localhost:8000
* User: `admin`
* Pass: `password`



## :wrench: Configuration

This setup allows you to configure a few settings via the `.env` file.

| Variable             | Default | Settings |
|----------------------|---------|----------|
| `LISTEN_PORT       ` | `8000`  | Local port for the web server to listen on |
| `RECAPTCHA_PRIV_KEY` |         | Required to make the captcha module work. (See [FAQ](#bulb-faq) section below) |
| `RECAPTCHA_PUB_KEY`  |         | Required to make the captcha module work. (See [FAQ](#bulb-faq) section below) |
| `PHP_DISPLAY_ERRORS` | `0`     | Set to `1` to display PHP errors (if you want a really easy mode) |

The following `.env` file variables are default settings and their values can also be changed from within the web interface:

| Variable         | Default  | Settings |
|------------------|----------|----------|
| `SECURITY_LEVEL` | `medium` | Adjust the difficulty level for the challenges<sup>[1]</sup><br/> (`low`, `medium`, `high` or `impossible`) |
| `PHPIDS_ENABLED` | `0`      | Set to `1` to enable PHP WAF/IDS<sup>[2]</sup> (off by default) |
| `PHPIDS_VERBOSE` | `0`      | Set to `1` to display WAF/IDS reasons for blocked requests |

> <sup>[1]</sup> For the `SECURITY_LEVEL` changes to take effect, you will have to clear your cookies. Alternatively change it in the web interface.<br/>
> <sup>[2]</sup> WAF (Web Application Firewall) / IDS (Intrusion Detection System)



## :bulb: FAQ

<details><summary><strong>Q:</strong> I want to proxy through <a href="https://portswigger.net/burp">BurpSuite</a>, but it does not work on <code>localhost</code> or <code>127.0.0.1</code>.</summary>
<p><br/>
Browsers ususally bypass <code>localhost</code> or <code>127.0.0.1</code> for proxy traffic. One solution is to add an alternative hostname to <code>/etc/hosts</code> and access the application through that.<br/><br/>
<code>/etc/hosts</code>:

```bash
127.0.0.1  dvwa
```

Then use <a href="http://dvwa:8000">http://dvwa:8000</a> in your browser.
</p>
</details>



<details><summary><strong>Q:</strong> How can I reset the database and start fresh?</summary>
<p><br/>
The database uses a Docker volume and you can simply remove it via:<br/>

```bash
# the command below will stop all running container,
# remove their state and delete the MySQL docker volume.
make reset
```
</p>
</details>



<details><summary><strong>Q:</strong> How can I view Apache access or error log files?</summary>
<p><br/>
Log files are piped to <i>stderr</i> from the Docker container and you can view them via:<br/>

```bash
make logs
```
</p>
</details>



<details><summary><strong>Q:</strong> How can I get a shell on the web server container?</summary>
<p><br/>
You can enter the running web server container via:<br/>

```bash
make enter
```
</p>
</details>



<details><summary><strong>Q:</strong> How do I setup the reCAPTCHA key?</summary>
<p><br/>
  Go to <a href="https://www.google.com/recaptcha/admin">https://www.google.com/recaptcha/admin</a> and generate your captcha as shown below:<br/>
  <ul>
   <li>Ensure to choose <code>reCAPTCHA v2</code></li>
   <li>Ensure to add <i>all</i> domains you plan on using</li>
  </ul>
  <a href="doc/captcha-01.png"><img src="doc/captcha-01-thumb.png" /></a>
  <ul>
   <li>Add <code>SITE KEY</code> to the <code>RECAPTCHA_PUB_KEY</code> variable in your <code>.env</code> file</li>
   <li>Add <code>SECRET KEY</code> to the <code>RECAPTCHA_PRIV_KEY</code> variable in your <code>.env</code> file</li>
  </ul>
  <a href="doc/captcha-02.png"><img src="doc/captcha-02-thumb.png" /></a>
</p>
</details>



<details><summary><strong>Q:</strong> How can I access/view the MySQL database?</summary>
<p><br/>
  <strong>Note:</strong> Doing so is basically cheating, but if you really need to, you can do so.<br/><br/>
  This Docker image bundles <a href="https://www.adminer.org/">Adminer</a> (a PHP web interace similar to phpMyAdmin) and you can access it here: <a href="http://localhost:8000/adminer.php">http://localhost:8000/adminer.php</a><br/>
  <ul>
   <li><strong>Server:</strong> <code>dvwa_db</code></li>
   <li><strong>Username:</strong> <code>root</code></li>
   <li><strong>Password:</strong> <code>rootpass</code></li>
  </ul>
  <img src="doc/adminer.png" />
</p>
</details>



## :lock: [cytopia](https://github.com/cytopia) sec tools

Below is a list of sec tools and docs I am maintaining, which might come in handy working on DVWA.

| Name                 | Category             | Language   | Description |
|----------------------|----------------------|------------|-------------|
| **[offsec]**         | Documentation        | Markdown   | Offsec checklist, tools and examples |
| **[header-fuzz]**    | Enumeration          | Bash       | Fuzz HTTP headers |
| **[smtp-user-enum]** | Enumeration          | Python 2+3 | SMTP users enumerator |
| **[urlbuster]**      | Enumeration          | Python 2+3 | Mutable web directory fuzzer |
| **[pwncat]**         | Pivoting             | Python 2+3 | Cross-platform netcat on steroids |
| **[badchars]**       | Reverse Engineering  | Python 2+3 | Badchar generator |
| **[fuzza]**          | Reverse Engineering  | Python 2+3 | TCP fuzzing tool |

[offsec]: https://github.com/cytopia/offsec
[header-fuzz]: https://github.com/cytopia/header-fuzz
[smtp-user-enum]: https://github.com/cytopia/smtp-user-enum
[urlbuster]: https://github.com/cytopia/urlbuster
[pwncat]: https://github.com/cytopia/pwncat
[badchars]: https://github.com/cytopia/badchars
[fuzza]: https://github.com/cytopia/fuzza



## :page_facing_up: License

**[MIT License](LICENSE.md)**

Copyright (c) 2021 **[cytopia](https://github.com/cytopia)**
