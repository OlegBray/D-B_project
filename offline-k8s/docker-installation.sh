mkdir -p ~/offline-k8s/docker
cd ~/offline-k8s/docker
apt download docker.io
apt download containerd
apt download runc

mkdir -p ~/offline-k8s/images
cd ~/offline-k8s/images
docker pull registry:2 && docker save registry:2 -o registry.tar


