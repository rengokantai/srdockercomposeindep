## srdockercomposeindep
####03 Installing Compose
```
curl -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
```

####04
docker-compose.yml
```
version: '2'
services:
  hello:
    image: tutum/hello-world
    ports:
      - 80
```
run in daemon mode
```
docker-compose up -d
```
####11 How restarts work
restart is running independently,however, restarts propagate (to its dependants) If db fails and restarts, then wordpress automatically restarts, whether it's running or failing

####15. Networking Overview
By default, the network is bridge, all containers visible to each other.

####16. The default network
example
```
version: '2'
services:
  a:
    image: tutum/hello-world
  b:
    image: tutum/hello-world
networks:
  default:
    driver: bridge
```
start
```
docker-compose up -d
docker inspect 123456
docker-compose exec a sh
ping b  //success
```
start with prject name
```
docker-compose --project-name ke up -d
```
