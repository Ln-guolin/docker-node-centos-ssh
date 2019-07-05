基于centos7搭建的nodejs环境

安装内容
```
容器基于：centos7
容器安装内容：
    nettool
    ssh
    wget
    node
    npm
    yarn
    
ssh用户密码：root/root
```

docker-compose.yml

```
version: "3"
services:
  node:
      image: guolin123/node:centos7-ssh
      restart: unless-stopped
      container_name: node
      ports:
        - '1022:22'
```


