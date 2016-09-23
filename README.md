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
