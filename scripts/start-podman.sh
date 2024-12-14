#!/usr/bin/env bash
set -x

# Constants:
# number of spark workers
NUM_WORKERS=2

# if not found, create a spark network:
# - make it acceble to the local network
if ! podman network inspect spark &> /dev/null; then
  podman network create --driver bridge --subnet 10.89.0.0/16 spark
fi

# define a podman pods for the controller and for workers to run a spark container
podman pod create --name spark-controller-pod --network spark
podman pod create --name spark-workers-pod --network spark

# start a spark controller container in the pod
podman run -d --pod spark-controller-pod --name spark-controller spark:latest


# start spark worker containers in the pod
for i in $(seq 1 $NUM_WORKERS); do
  podman run -d --pod spark-workers-pod --name spark-worker-$i spark:latest
done
