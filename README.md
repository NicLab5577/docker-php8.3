# docker-php8.3-apache

A Debian LAMP container

It's on [docker-hub](https://hub.docker.com/repository/docker/niclab/php8.3/) and [github](https://github.com/NicLab5577/docker-php8.3)

## tags and links
* `latest` [(main/Dockerfile)](https://github.com/NicLab5577/docker-php8.3/blob/main/Dockerfile)

## how to build

```sh
git clone git@github.com:NicLab5577/docker-php8.3.git
cd docker-php8.3
docker build --rm -t niclab/php8.3 .
```

## running

```sh
docker-compose up -d
```