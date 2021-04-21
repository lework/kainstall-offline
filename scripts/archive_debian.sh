#!/bin/env bash

mkdir -p /data/{all,kubeadm,worker,kernel}
cd /data
ls -alhR ./*

apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg2 lsb-release

KUBE_VERSION=${1:-1.20.6}
OS_CODENAME="$(lsb_release -cs)"

function download_deb() {
  path=${1-./}
  packages=${@:2}
  
  (cd $path; apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests \
          --no-conflicts --no-breaks --no-replaces --no-enhances \
            --no-pre-depends ${packages} | grep "^\w"))
}

echo "[download kernel package]"
echo "deb http://mirrors.aliyun.com/debian ${OS_CODENAME}-backports main" > /etc/apt/sources.list.d/backports.list
apt-get update
download_deb /data/kernel/ linux-image-amd64 linux-headers-amd64

echo "[download common node package]"
download_deb /data/all sshpass openssh-server openssh-client openssl wget gzip ipvsadm ipset sysstat conntrack libseccomp2 unzip chrony bash-completion auditd audispd-plugins

echo "[download docker package]"
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg | apt-key add -
echo "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/debian ${OS_CODENAME} stable" > /etc/apt/sources.list.d/docker-ce.list
apt-get update
download_deb /data/all docker-ce docker-ce-cli containerd.io

echo "[download kubeadm package]"
echo 'deb https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list
curl -s https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
apt-get update
download_deb /data/kubeadm kubeadm=$KUBE_VERSION-00 kubelet=$KUBE_VERSION-00 kubectl=$KUBE_VERSION-00

echo "[download worker node package]"
download_deb /data/worker haproxy

echo "[move lib package]"
mv -fv /data/kubeadm/lib* /data/all/
mv -fv /data/worker/lib* /data/all/
mv -fv /data/kernel/lib* /data/all/

echo "[dependency package]"
dpkg -i /data/all/*.deb || apt-get --download-only -o Dir::Cache::archives="/data/all" -f -y install

echo "[clean]"
rm -rfv /data/{all,kubeadm,worker,kernel}/{lock,partial}