#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------#
# 
# @Autor : Utrains
# Description : This is the script that will take care of the installation of Java, Jenkins server and some utilitiess
# Date : 03/22/2022
#   
#------------------------------------------------------------------------------------------------------------------#


## Recover the ip address and update the server
IP=$(hostname -I | awk '{print $2}')
echo "START - install jenkins - "$IP
echo "=====> [1]: updating ...."
sudo yum update -qq >/dev/null

## Prerequisites tools(Curl, Wget, ...) for Jenkins

echo "=====> [2]: install prerequisite tools for Jenkins"


# Although not needed for Jenkins, I like to use vim, so let's make sure it is installed:
sudo yum install -y vim

# The Jenkins setup makes use of wget, so let's make sure it is installed:
sudo yum install -y wget

# Let's install sshpass
sudo yum install -y sshpass

# Let's install gnupg2
sudo yum install -y gnupg2

# gnupg2 openssl :
sudo yum install -y openssl

# gnupg2 curl:
sudo yum install -y curl

# Jenkins on CentOS requires Java, but it won't work with the default (GCJ) version of Java. So, let's remove it:
sudo yum remove -y java*

# install the OpenJDK version of Java 11:
sudo yum install java-11-openjdk -y

# Jenkins uses 'ant' so let's make sure it is installed:

# Let's now install Jenkins:
echo "===== =================> [3]: Choose Java 11 for Jenkins installation ...."
sudo update-alternatives --set java /usr/lib/jvm/java-11-openjdk-11.0.16.0.8-1.el7_9.x86_64/bin/java
java -version

echo "=====> [3]: installing Jenkins ...."
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins

echo "=====> [4]: updating server after jenkins installation ...."
sudo yum update -y

echo "=====> [5]: Start Jenkins Daemon and Enable ...."
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "=====> [6]: Ajust Firewall ...."
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --reload

echo "END - install jenkins"