# kainstall-offline

[kainstall](https://github.com/lework/kainstall) 安装程序的离线包

> 离线包解决了大部分软件包下载的问题，但各自系统环境的软件版本都不一致，所以实际安装中还需要下载一小部分依赖包，这时需要系统联网或者有内部仓库。



## 文件列表

查看 [releases](https://github.com/lework/kainstall-offline/releases) 文件


## 文件内容

> 只含有 kainstall 默认使用的文件。

压缩包内容 [file_list](https://github.com/lework/kainstall-offline/tree/master/file_list)

### packages

| 用途    | 包名                                                         |
| ------- | ------------------------------------------------------------ |
| all     | sshpass openssh curl wget gzip ipvsadm ipset sysstat conntrack unzip epel-release chrony bash-completion docker-ce docker-ce-cli containerd.io libselinux libseccomp systemd systemd-libs systemd-python audit |
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
