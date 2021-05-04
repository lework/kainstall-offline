#!/bin/env bash

KUBE_VERSION=${1:-1.19.2}

mkdir -p /data/{all,kubeadm,worker,kernel}
cd /data
ls -alhR ./*

yum install -y epel-release yum-utils

echo "[download kernel package]"
ver=$(rpm --eval '%{centos_ver}')
curl https://www.elrepo.org/elrepo-release-${ver}.el${ver}.elrepo.noarch.rpm -o /data/kernel/elrepo-release-${ver}.el${ver}.elrepo.noarch.rpm
yum localinstall -y kernel/elrepo-release-${ver}.el${ver}.elrepo.noarch.rpm
yum install -y --downloadonly --downloaddir=kernel --enablerepo=elrepo-kernel kernel-ml kernel-devel
ls -alhR kernel/*

echo "[download common node package]"
yum install -y --downloadonly --downloaddir=all sshpass openssh openssl curl wget gzip ipvsadm ipset sysstat conntrack libseccomp unzip epel-release chrony bash-completion audit
[ "${ver}" == "7" ] && yum install -y --downloadonly --downloaddir=all systemd-python
yum reinstall -y --downloadonly --downloaddir=all gzip wget libselinux libseccomp audit-libs

echo "[download docker package]"
yum-config-manager --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum install -y --downloadonly --downloaddir=all docker-ce docker-ce-cli containerd.io
ls -alhR all/*

echo "[download kubeadm package]"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
yum install -y --downloadonly --downloaddir=kubeadm --disableexcludes=kubernetes kubeadm-${KUBE_VERSION} kubelet-${KUBE_VERSION} kubectl-${KUBE_VERSION}
ls -alhR kubeadm/*

echo "[download worker node package]"
yum install -y --downloadonly --downloaddir=worker haproxy
ls -alhR worker/*
