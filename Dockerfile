# Jenkins Slave for building spring boot apps with maven
FROM centos:centos7
MAINTAINER Sascha Guggenberger<guggens@googlemail.com>

# Upgrade packages on image, install openssh-server and git
RUN yum update -y &&\
    yum install -y openssh-server &&\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    mkdir -p /var/run/sshd

# Set user jenkins to the image
RUN useradd -m -d /home/jenkins -s /bin/sh jenkins &&\
    echo "jenkins:jenkins" | chpasswd

# Standard SSH port
EXPOSE 22

# Default command
CMD ["/usr/sbin/sshd", "-D"]
