echo "Updating YUM"
yum -y update

echo "Installing and Setting up Docker"
yum -y install docker
systemctl enable docker && systemctl start docker

echo "[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" > /etc/yum.repos.d/kubernetes.repo

echo "br_netfilter" > /etc/modules-load.d/k8s.conf

echo "net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1" > /etc/sysctl.d/k8s.conf
sudo sysctl --system

sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

echo "Installed and setting up Kuberenetes Dependencies"
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

sudo sed -i '/swap/d' /etc/fstab
sudo swapoff -a