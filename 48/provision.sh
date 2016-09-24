#! /bin/bash

set -e
USAGE=$(cat <<USAGE
Usage: $0 <options>

Provision 3 node docker swarm cluster ($$)

Options:
  -h  help
  -d  Digitalocean token
  -c  cleanup 
)
 
while [ $# -gt 0 ];do
  case "$1" in
    -h)
      echo "$USAGE"; exit 2; shift;;
    -d)
      DIGITALOCEANTOKEN=$2;shift 2;;
    -c)
      CLEANUP=1;shift 1;;
    -*) echo "Invalid $1"; exit 1;;
    *) break;;
  esac
done
 
if [ -n "$DIGITALOCEANTOKEN" ]; then
  echo "provisioning swarm using digitalocean..."
  export DIGITALOCEANTOKEN=$DIGITALOCEANTOKEN
  export MACHINE_DRIVER=digitalocean
else
  echo "provisioning swarm using virtualbox..."
  export MACHINE_DRIVER=virtualbox
fi
 
create_consul() {
  docker-machine create consul
  eval $(docker-machine env consul)
   
  docker run --detach --name consul --publish "8500:8500" --hostname "consul" progium/consul -server -bootstrap
   
  docker run --link consul --rm martin/wait
}
create_machine(){
  docker-machine create --swarm --swarm-discovery "consul://$(docker-machine ip consul):8500" --engine-opt "cluster-store=consul://$(docker-machine ip consul):8500" --engine-opt "cluster-advertise=eth1:2376" $@
}
 
set -x
 
create_consul
 
create_machine --swarm-master swarm-manager
create_machine "node1"
create_machine "node2"
create_machine --swarm-master swarm-manager
