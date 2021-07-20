#!/bin/env bash


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
  
  docker pull k8s.gcr.io/metrics-server/metrics-server:v0.5.0
  docker tag k8s.gcr.io/metrics-server/metrics-server:v0.5.0 registry.cn-hangzhou.aliyuncs.com/kainstall/metrics-server:v0.5.0
  docker rmi k8s.gcr.io/metrics-server/metrics-server:v0.5.0
    
  docker pull quay.io/coreos/flannel:v0.14.0
  docker pull kubernetesui/metrics-scraper:v1.0.6
  docker pull kubernetesui/dashboard:v2.3.1
  docker pull traefik/whoami:v1.6.1
  docker pull traefik:v2.4.11
    
  docker pull jettech/kube-webhook-certgen:v1.5.1
  docker pull k8s.gcr.io/ingress-nginx/controller:v0.48.1
  docker tag k8s.gcr.io/ingress-nginx/controller:v0.48.1 registry.cn-hangzhou.aliyuncs.com/kainstall/controller:v0.48.1
  docker rmi k8s.gcr.io/ingress-nginx/controller:v0.48.1
    
  docker pull k8s.gcr.io/defaultbackend-amd64:1.5
  docker tag k8s.gcr.io/defaultbackend-amd64:1.5 registry.cn-hangzhou.aliyuncs.com/kainstall/defaultbackend-amd64:1.5
  docker rmi k8s.gcr.io/defaultbackend-amd64:1.5
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
  wget https://cdn.jsdelivr.net/gh/coreos/flannel@v0.14.0/Documentation/kube-flannel.yml -o /dev/null -O ${manifest_dir}/kube-flannel.yml
  wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.0/components.yaml -o /dev/null -O ${manifest_dir}/metrics-server.yml
  wget https://cdn.jsdelivr.net/gh/kubernetes/ingress-nginx@controller-v0.48.1/deploy/static/provider/baremetal/deploy.yaml -o /dev/null -O ${manifest_dir}/ingress-nginx.yml
  wget https://cdn.jsdelivr.net/gh/kubernetes/dashboard@v2.3.1/aio/deploy/recommended.yaml -o /dev/null -O ${manifest_dir}/kubernetes-dashboard.yml
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