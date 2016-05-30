# Jenkins Slave for building spring boot apps with maven
FROM centos:centos7
MAINTAINER Sascha Guggenberger<guggens@googlemail.com>

# Upgrade packages on image, install openssh-server and git
RUN yum update -y &&\
    yum install -y openssh-server &&\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    mkdir -p /var/run/sshd
    
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
