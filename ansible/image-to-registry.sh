# On each node, extract and load RKE2 images
sudo zstd -d /tmp/rke2/rke2-images.linux-amd64.tar.zst
sudo docker load -i /tmp/rke2/rke2-images.linux-amd64.tar

# Find CNI-related images
sudo docker images | grep -E "(rancher|canal|flannel|calico)"

# Tag and push to local registry
sudo docker images | grep -E "(rancher|canal|flannel|calico)" | awk '{print $1":"$2}' | while read image; do
    sudo docker tag $image localhost:5000/$image
    sudo docker push localhost:5000/$image
done
