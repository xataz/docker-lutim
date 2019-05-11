![](https://framagit.org/luc/lutim/raw/master/themes/default/public/img/lutim128.png)

[![Build Status](https://drone.xataz.net/api/badges/xataz/docker-lutim/status.svg)](https://drone.xataz.net/xataz/docker-lutim)
[![](https://images.microbadger.com/badges/image/xataz/lutim.svg)](https://microbadger.com/images/xataz/lutim "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/xataz/lutim.svg)](https://microbadger.com/images/xataz/lutim "Get your own version badge on microbadger.com")

> This image is build and push with [drone.io](https://github.com/drone/drone), a circle-ci like self-hosted.
> If you don't trust, you can build yourself.

## Tag available
* latest, 0.11.5, 0.11.4, 0.11, 0 [(Dockerfile)](https://github.com/xataz/docker-lutim/blob/master/Dockerfile)

## Description
What is [Lutim](https://framagit.org/luc/lutim) ?

It means Let's Upload That Image.

It stores images and allows you to see them, download them or share them on social networks. From version 0.5, gif images can be displayed as animated gifs in Twitter, but you need a HTTPS server (Twitter requires that. Lutim detects if you have a HTTPS server and displays a static image twitter card if you don't);

Images are indefinitly stored unless you request that they will be deleted at first view or after 24 hours / one week / one month / one year.

**This image does not contain root processes**

## BUILD IMAGE

```shell
docker build -t xataz/lutim github.com/xataz/docker-lutim.git#master
```

## Configuration
### Environments
* UID : choose uid for launching lutim (default : 991)
* GID : choose gid for launching lutim (default : 991)
* WEBROOT : webroot of lutim (default : /)
* SECRET : random string used to encrypt cookies (default : e7c0b28877f7479fe6711720475dcbbd)
* MAX_FILE_SIZE : maximum file size of an uploaded file in bytes (default : 10000000000)
* CONTACT : lutim contact (default : contact@domain.tld)
* DEFAULT_DELAY : default time limit for files in days (default : 1 (0 for unlimited))
* MAX_DELAY : number of days after which the images will be deleted (default : 0 for unlimited)

Tip : you can use the following command to generate SECRET. `date +%s | md5sum | head -c 32`

### Volumes
* /usr/lutim/lutim.conf : Lutim's configuration file is here
* /usr/lutim/data : Lutim's database is here
* /usr/lutim/files : Location of uploaded images

### Ports
* 8181

## Usage
### Simple launch
```shell
docker run -d -p 8181:8181 xataz/lutim
```
URI access : http://XX.XX.XX.XX:8181

### Advanced launch
```shell
docker run -d -p 8080:8181 \
    -v /docker/config/lutim/data:/usr/lutim/data \
    -v /docker/data/lutim:/usr/lutim/files \
    -e UID=1001 \
    -e GID=1001 \
    -e WEBROOT=/lutim \
    -e SECRET=$(date +%s | md5sum | head -c 32) \
    -e CONTACT=contact@mydomain.com \
    -e MAX_FILE_SIZE=250000000 \
    xataz/lutim
```
URI access : http://XX.XX.XX.XX:8080/lutim

## Contributing
Any contributions are very welcome !
