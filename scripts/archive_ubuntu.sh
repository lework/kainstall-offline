#!/bin/env bash


mkdir -p /data/{all,kubeadm,worker,kernel}
cd /data
ls -alhR ./*

#apt-get update
#apt-get install -y curl lsb-release

KUBE_VERSION=${1:-1.20.6}
OS_CODENAME="$(awk -F'=' '/UBUNTU_CODENAME/ {print $2}' /etc/os-release)"

cat << EOF > /etc/apt/apt.conf.d/99verify-peer.conf 
Acquire::https::Verify-Peer "false";
Acquire::https::Verify-Host "false";
EOF

export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
echo "tzdata tzdata/Areas select Asia" > /tmp/preseed.cfg
echo "tzdata tzdata/Zones/Asia select Shanghai" >> /tmp/preseed.cfg
debconf-set-selections /tmp/preseed.cfg

function download_deb() {
  path=${1-./}
  packages=${@:2}
  
  apt-get --download-only -o Dir::Cache::archives="${path}" -d -y install ${packages} || exit 1
  
  packages_rep=""
  for i in $packages; do
    packages_rep="${i//=*}|${packages_rep}"
  done
  packages_depends=$(apt-cache depends --recurse --no-recommends --no-suggests \
                      --no-conflicts --no-breaks --no-replaces --no-enhances \
                      --no-pre-depends ${packages} | grep "^\w" | grep -Ev "${packages_rep}")
 (cd $path; apt-get download ${packages_depends} || exit 1)
}

echo "[download kernel package]"
apt update -y --allow-unauthenticated
download_deb /data/kernel/ linux-headers-generic linux-image-generic

echo "[download common node package]"
download_deb /data/all sshpass openssh-server openssh-client openssl wget gzip ipvsadm ipset sysstat conntrack libseccomp2 unzip chrony bash-completion auditd audispd-plugins apt-transport-https ca-certificates curl gnupg lsb-release

echo "[download docker package]"
echo "deb [trusted=yes] https://download.docker.com/linux/ubuntu ${OS_CODENAME} stable" > /etc/apt/sources.list.d/docker-ce.list

[ "${OS_CODENAME}" == "stretch" ] && apt-get -y install apt-transport-https  
apt update -y --allow-unauthenticated
download_deb /data/all docker-ce docker-ce-cli containerd.io

echo "[download kubeadm package]"
echo 'deb [trusted=yes] https://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list

apt update -y --allow-unauthenticated
download_deb /data/kubeadm kubeadm=$KUBE_VERSION-00 kubelet=$KUBE_VERSION-00 kubectl=$KUBE_VERSION-00

echo "[download worker node package]"
download_deb /data/worker haproxy

echo "[move lib package]"
mv -fv /data/kubeadm/{lib*,readline*,lsb-base*} /data/all/
mv -fv /data/worker/{lib*,readline*,lsb-base*} /data/all/

echo "[dependency package]"
dpkg -i /data/all/*.deb || apt-get --download-only -o Dir::Cache::archives="/data/all" -f -y install

echo "[clean]"
rm -rfv /data/{all,kubeadm,worker,kernel}/{lock,partial}
