#!/bin/bash

# Store assets here
DOWNLOAD_DIR=${HOME}/offline-k8s/rke2
VERSION=1.31.8

mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

echo "⬇️ Downloading RKE2 assets for v${VERSION}+rke2r1 ..."

curl -OLs "https://github.com/rancher/rke2/releases/download/v${VERSION}%2Brke2r1/rke2-images.linux-amd64.tar.zst"
curl -OLs "https://github.com/rancher/rke2/releases/download/v${VERSION}%2Brke2r1/rke2.linux-amd64.tar.gz"
curl -OLs "https://github.com/rancher/rke2/releases/download/v${VERSION}%2Brke2r1/sha256sum-amd64.txt"
curl -sfL https://get.rke2.io -o install.sh

echo "✅ Done: All assets downloaded to $DOWNLOAD_DIR"
