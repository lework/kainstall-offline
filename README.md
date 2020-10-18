# kainstall-offline

[kainstall](https://github.com/lework/kainstall) 安装程序的离线包



## 文件列表

| 时间 | kube 版本 | 文件大小 | 下载链接 |
| --------- | -------- | ----------- | ----------- |
| 2020-10-18_11:46:46 | 1.18.10 | 835M | [centos7](http://kainstall.oss-cn-shanghai.aliyuncs.com/1.18.10/centos7.tgz) |
| 2020-10-18_11:37:34 | 1.17.13 | 838M | [centos8](http://kainstall.oss-cn-shanghai.aliyuncs.com/1.17.13/centos8.tgz) |
| 2020-10-18_11:32:20 | 1.17.13 | 833M | [centos7](http://kainstall.oss-cn-shanghai.aliyuncs.com/1.17.13/centos7.tgz) |
| 2020-10-18_11:21:08 | 1.16.15 | 823M | [centos8](http://kainstall.oss-cn-shanghai.aliyuncs.com/1.16.15/centos8.tgz) |
| 2020-10-18_11:15:39 | 1.16.15 | 819M | [centos7](http://kainstall.oss-cn-shanghai.aliyuncs.com/1.16.15/centos7.tgz) |



## 文件内容

> 只含有 kainstall 默认使用的文件。

### rpms

| 用途    | 包名                                                         |
| ------- | ------------------------------------------------------------ |
| all     | sshpass openssh wget gzip ipvsadm ipset sysstat conntrack libseccomp unzip epel-release chrony bash-completion docker-ce docker-ce-cli containerd.io |
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


## License

MIT
