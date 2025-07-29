mkdir -p ~/offline-k8s/docker
cd ~/offline-k8s/docker
apt download docker.io
apt download containerd
apt download runc

mkdir -p ~/offline-k8s/images
cd ~/offline-k8s/images
docker pull registry:2 && docker save registry:2 -o registry.tar

docker pull nginx:latest && docker save nginx:latest -o nginx.tar

aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 602401143452.dkr.ecr.eu-central-1.amazonaws.com

# Pull and save AWS Load Balancer Controller image
docker pull 602401143452.dkr.ecr.eu-central-1.amazonaws.com/amazon/aws-load-balancer-controller:v2.7.1 && \
docker save -o aws-lbc.tar 602401143452.dkr.ecr.eu-central-1.amazonaws.com/amazon/aws-load-balancer-controller:v2.7.1

# Pull and save cert-manager images
docker pull quay.io/jetstack/cert-manager-controller:v1.13.3
docker save -o cert-manager-controller.tar quay.io/jetstack/cert-manager-controller:v1.13.3

docker pull quay.io/jetstack/cert-manager-webhook:v1.13.3
docker save -o cert-manager-webhook.tar quay.io/jetstack/cert-manager-webhook:v1.13.3

docker pull quay.io/jetstack/cert-manager-cainjector:v1.13.3
docker save -o cert-manager-cainjector.tar quay.io/jetstack/cert-manager-cainjector:v1.13.3
