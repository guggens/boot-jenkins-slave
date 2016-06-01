# Jenkins Slave for building spring boot apps with maven
FROM centos:centos7
MAINTAINER Sascha Guggenberger<guggens@googlemail.com>

# Upgrade packages on image, install openssh-server and git
RUN yum update -y &&\
    yum install -y openssh-server &&\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    mkdir -p /var/run/sshd
    
# install wget
RUN yum install -y wget
    
# install oracle jdk 8 - from http://lintut.com/how-to-install-java-8-on-rhel-centos-7-x-and-fedora-linux/
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-x64.rpm" &&\
    rpm -ivh jdk-8u91-linux-x64.rpm &&\
    yum remove -y java-1.7.0* &&\
    java -version
  
# install git
RUN yum install -y git

# install maven
RUN wget http://mirror.synyx.de/apache/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz &&\
    pwd &&\
    tar xzvf apache-maven-3.2.5-bin.tar.gz &&\
    export PATH=./apache-maven-3.2.5/bin:$PATH &&\
    mvn -version
    
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key &&\
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key &&\
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
    
# Set user jenkins to the image
RUN useradd -m -d /home/jenkins -s /bin/sh jenkins &&\
    echo "jenkins:jenkins" | chpasswd

# Standard SSH port
EXPOSE 22

# Default command
CMD ["/usr/sbin/sshd", "-D"]
