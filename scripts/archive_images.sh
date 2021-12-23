#!/bin/env bash

function rename_tag() {
  source=$1
  dest=$2

  docker pull "${source}"
  docker tag "${source}" "${dest}"
  docker rmi "${source}"
  docker images "${dest}"
}

function archive_images() {
  images_dir="${1:-.}/images"
  [ ! -d ${images_dir} ] && mkdir -pv ${images_dir} || sudo rm -rfv ${images_dir}/*
  
  echo "[download images]"
  kubeadm config images pull --kubernetes-version ${KUBE_VERSION}
  if [[ "${KUBE_VERSION}" == "1.21.1" ]]; then
    docker images --format '{{.Repository}}:{{.Tag}}' | grep k8s.gcr.io/coredns | awk -F'k8s.gcr.io/' '{print "docker tag " $0 " docker.io/" $2}' | bash
  fi
  docker images --format '{{.Repository}}:{{.Tag}}' | grep k8s.gcr.io | awk -F'k8s.gcr.io/' '{print "docker tag " $0 " registry.cn-hangzhou.aliyuncs.com/kainstall/" $2}' | bash
  docker rmi $(docker images --format '{{.Repository}}:{{.Tag}}' | grep k8s.gcr.io)
  
  rename_tag k8s.gcr.io/metrics-server/metrics-server:v0.5.2 registry.cn-hangzhou.aliyuncs.com/kainstall/metrics-server:v0.5.2
  rename_tag quay.io/coreos/flannel:v0.15.1 registry.cn-hangzhou.aliyuncs.com/kainstall/flannel:v0.15.1
  docker pull rancher/mirrored-flannelcni-flannel-cni-plugin:v1.0.0
  
  docker pull kubernetesui/metrics-scraper:v1.0.7
  docker pull kubernetesui/dashboard:v2.4.0
  docker pull traefik/whoami:v1.7.1
  docker pull traefik:v2.5.6
    
  rename_tag k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1 registry.cn-hangzhou.aliyuncs.com/kainstall/kube-webhook-certgen:v1.1.1
  rename_tag k8s.gcr.io/ingress-nginx/controller:v1.1.0 registry.cn-hangzhou.aliyuncs.com/kainstall/controller:v1.1.0

  rename_tag k8s.gcr.io/defaultbackend-amd64:1.5 registry.cn-hangzhou.aliyuncs.com/kainstall/defaultbackend-amd64:1.5
  docker images
   
  master="etcd|kube-scheduler|kube-controller-manager|kube-apiserver"
  all="kube-proxy|coredns|flannel|pause"
    
  echo "[save images]"
  docker save $(docker images --format '{{.Repository}}:{{.Tag}}' | grep -E "${master}") | gzip > ${images_dir}/master.tgz
  docker save $(docker images --format '{{.Repository}}:{{.Tag}}' | grep -E "${all}") | gzip > ${images_dir}/all.tgz
  docker save $(docker images --format '{{.Repository}}:{{.Tag}}' | grep -vE "${master}" | grep -vE "${all}") | gzip > ${images_dir}/worker.tgz
}


function archive_manifests() {
  manifest_dir="${1:-.}/manifests"
  [ ! -d ${manifest_dir} ] && mkdir -pv ${manifest_dir} || sudo rm -rfv ${manifest_dir}/*
  
  echo "[download manifest]"
  wget https://cdn.jsdelivr.net/gh/coreos/flannel@v0.15.1/Documentation/kube-flannel.yml -o /dev/null -O ${manifest_dir}/kube-flannel.yml
  wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.2/components.yaml -o /dev/null -O ${manifest_dir}/metrics-server.yml
  wget https://cdn.jsdelivr.net/gh/kubernetes/ingress-nginx@controller-v1.1.0/deploy/static/provider/baremetal/deploy.yaml -o /dev/null -O ${manifest_dir}/ingress-nginx.yml
  wget https://cdn.jsdelivr.net/gh/kubernetes/dashboard@v2.4.0/aio/deploy/recommended.yaml -o /dev/null -O ${manifest_dir}/kubernetes-dashboard.yml
}

function archive_bins() {
  bin_dir="${1:-.}/bins"
  [ ! -d ${bin_dir} ] && mkdir -pv ${bin_dir} || sudo rm -rfv ${bin_dir}/*
  
  echo "[download bin]"
  wget https://github.com/lework/kubeadm-certs/releases/download/v${KUBE_VERSION}/kubeadm-linux-amd64 -o /dev/null -O ${bin_dir}/kubeadm-linux-amd64
}

archive_images $1
archive_manifests $1
archive_bins $1