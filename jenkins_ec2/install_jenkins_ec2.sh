#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------#
# @Autor : Utrains
# Description : This is the script that will take care of the installation of Java, 
#               Jenkins server and some utilitiess
# Date : 03/22/2022
#------------------------------------------------------------------------------------------------------------------#

## Recover the ip address and update the server
IP=$(hostname -I | awk '{print $2}')
echo "START - install jenkins - "$IP
echo "=====> [1]: updating ...."
sudo yum update -y

## Prerequisites tools(Curl, Wget, ...) for Jenkins

echo "=====> [2]: install prerequisite tools for Jenkins"

# Let's install yum-presto:
sudo yum install -y yum-presto

# Although not needed for Jenkins, I like to use vim, so let's make sure it is installed:
sudo yum install -y vim

# The Jenkins setup makes use of wget, so let's make sure it is installed:
sudo yum install -y wget

# Let's install sshpass
sudo yum install -y sshpass

# Let's install gnupg2
sudo yum install -y gnupg2

# Let's make sure that we have the EPEL and IUS repositories installed.
# This will allow us to use newer binaries than are found in the standard CentOS repositories.
sudo wget -N http://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-13.ius.centos7.noarch.rpm
sudo rpm -Uvh ius-release*.rpm

# gnupg2 openssl :
sudo yum install -y openssl

# gnupg2 curl:
sudo yum install -y curl

# Jenkins on CentOS requires Java, but it won't work with the default (GCJ) version of Java. So, let's remove it:
sudo yum remove -y java

# install the OpenJDK version of Java 8:
sudo yum install -y java-1.8.0-openjdk-devel

# Jenkins uses 'ant' so let's make sure it is installed:
sudo yum install -y ant

# Let's now install Jenkins:
echo "=====> [3]: installing Jenkins ...."
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum install -y jenkins

echo "=====> [4]: updating server after jenkins installation ...."
sudo yum update -y

echo "=====> [5]: Start Jenkins Daemon and Enable ...."
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "=====> [6]: Ajust Firewall ...."
sudo yum install -y firewalld
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --reload

echo "END - install jenkins"