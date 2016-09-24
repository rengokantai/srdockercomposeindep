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
  location / {
    return 200 "hello";
  }
}
```
Note:
```
ports:
      - 80  //this is port number only on container machine
```
test, get port number on host machine
```
docker-compose port nginx 80
```
then
```
curl localhost:port
```
or
```
docker-compose port nginx 80 | awk -F : '{print "localhost:" $2}'|xargs curl
docker-compose inspect root_nginx_1
```
#####26 Named volumes -- communication between volumes
see yml,then scale it
```
docker-compose scale worker=2
```
check volume folder
```
docker-compose exec worker ls /res
```
put file and check the result in other container
```
docker exec root_worker_1 touch /res/ke
docker exec root_worker_2 ls /res
```

check all volume
```
docker volume ls
```
we create another service called report using volumes_from directive,we set it readonly,so this is error:
```
docker-compose exec report touch /res/k
```
