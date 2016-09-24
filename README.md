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
####18 Isolating containers
if the network names are
```
front
back
```
server names are
```
a
b
c
```
username is root,then
```
docker network inspect root_front
```
#####19. Using external networks
```
docker network create --driver bridge ke
docker run -d --name hello --net ke tutum/hello-world
docker network inspect ke
```

running docker-compose.yml, then
```
docker-compose exec ping -c1 hello
docker-compose exec ping -c1 h
```
#####20. Aliases and container names
see yml file,
```
docker-compose exec a ping -c1 web //success
docker-compose exec a ping -c1 website //fail
```
we can update container name
```
container_name: foo
```
#####21. Links
see yml file, we can ping using new name
```
docker-compose exec a ping -c1 bee
```
#####25 simple volume
a nginx config default.conf
```
server {
  listen 80;
  server_name localhost;
  lsiten / {
    return 200 "hello";
  }
}
```
