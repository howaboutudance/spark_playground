#!/usr/bin/env bash
set -x

# if controller pod exists:
# - stop the containers in it
# - remove the pod
if podman pod exists spark-controller-pod; then
  podman stop spark-controller
  podman pod rm spark-controller-pod
fi

# if workers pod exists:
# - stop the containers in it (by name)
# - remove the pod
if podman pod exists spark-workers-pod; then
  podman stop $(podman ps -a --filter "name=spark-worker" -q)
  podman pod rm spark-workers-pod
fi

# if conditional flag --all is set, remove the spark network
if [[ $1 == "--all" ]]; then
  podman network rm spark
fi