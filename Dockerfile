FROM centos:7

MAINTAINER ln <root@soilove.cn>

# 安装wget，用于下载，安装网络包，支持netstat命令
RUN yum update -y && yum install -y wget && yum install -y net-tools && yum install -y sudo

### nodejs + npm + yarn 环境安装

# 安装node源
RUN curl --silent --location https://rpm.nodesource.com/setup_12.x | bash -

# 安装nodejs 和 npm
RUN yum install -y nodejs

# 继续安装依赖
RUN yum install -y gcc-c++ make

# 安装yarn源
RUN curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo

# 安装yarn
RUN yum install -y yarn


### ssh 工具安装

# 安装openssh-server和sudo软件包，并且将sshd的UsePAM参数设置成no
RUN yum install -y openssh-server
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
# 安装openssh-clients
RUN yum  install -y openssh-clients

# 清理软件包
RUN yum clean all

# 添加测试用户root，密码root，并且将此用户添加到sudoers里
RUN echo "root:root" | chpasswd
RUN echo "root   ALL=(ALL)       ALL" >> /etc/sudoers

# 下面这两句比较特殊，在centos6上必须要有，否则创建出来的容器sshd不能登录
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_ecdsa_key
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key

# 启动sshd服务并且暴露22端口
RUN mkdir /var/run/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
