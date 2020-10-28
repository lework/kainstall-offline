# kainstall-offline

[kainstall](https://github.com/lework/kainstall) 安装程序的离线包



## 文件列表

| 时间 | kube 版本 | 文件大小 | 内容列表 | 下载链接 |
| --------- | -------- | ----------- | ----------- | ----------- |
| 2020-10-28_05:55:30 | 1.16.15 | 832M | [1.16.15_centos8.txt](./file_list/1.16.15_centos8.txt)  | [centos8](http://kainstall.oss-cn-shanghai.aliyuncs.com/1.16.15/centos8.tgz) |
| 2020-10-28_05:50:11 | 1.16.15 | 828M | [1.16.15_centos7.txt](./file_list/1.16.15_centos7.txt)  | [centos7](http://kainstall.oss-cn-shanghai.aliyuncs.com/1.16.15/centos7.tgz) |
| 2020-10-28_05:42:54 | 1.15.12 | 807M | [1.15.12_centos8.txt](./file_list/1.15.12_centos8.txt)  | [centos8](http://kainstall.oss-cn-shanghai.aliyuncs.com/1.15.12/centos8.tgz) |
| 2020-10-28_05:37:01 | 1.15.12 | 803M | [1.15.12_centos7.txt](./file_list/1.15.12_centos7.txt)  | [centos7](http://kainstall.oss-cn-shanghai.aliyuncs.com/1.15.12/centos7.tgz) |
| 2020-10-21_13:46:25 | 1.19.3 | 812M | [1.19.3_centos8.txt](./file_list/1.19.3_centos8.txt)  | [centos8](http://kainstall.oss-cn-shanghai.aliyuncs.com/1.19.3/centos8.tgz) |
| 2020-10-21_13:40:39 | 1.19.3 | 808M | [1.19.3_centos7.txt](./file_list/1.19.3_centos7.txt)  | [centos7](http://kainstall.oss-cn-shanghai.aliyuncs.com/1.19.3/centos7.tgz) |



## 文件内容

> 只含有 kainstall 默认使用的文件。

### rpms

| 用途    | 包名                                                         |
| ------- | ------------------------------------------------------------ |
| all     | sshpass openssh wget gzip ipvsadm ipset sysstat conntrack unzip epel-release chrony bash-completion docker-ce docker-ce-cli containerd.io libselinux libseccomp systemd systemd-libs systemd-python audit |
| kubeadm | kubeadm kubelet  kubectl                                     |
| worker  | haproxy                                                      |
| kernel  | kernel-ml kernel-devel                                       |

### images

| 用途   | 镜像                                                         |
| ------ | ------------------------------------------------------------ |
| all    | kube-proxy flannel pause                                     |
| master | etcd kube-scheduler kube-controller-manager kube-apiserver coredns |
| worker | metrics-server metrics-scraper kubernetesui dashboard kube-webhook-certgen whoami traefik ingress-nginx-controller defaultbackend |

### manifests

- kube-flannel
- metrics-server
- ingress-nginx-controller
- kubernetes-dashboard

### bins

- kubeadm-linux-amd64 ([10years cert](https://github.com/lework/kubeadm-certs))

## License

MIT
