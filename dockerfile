FROM ubuntu:22.04
RUN apt update && apt upgrade -y && apt install -y vim sudo build-essential git openjdk-11-jdk net-tools iputils-ping openssh-server iperf ncat python3-pip python3-venv telnet traceroute golang-go perl
RUN echo root:password | chpasswd &&\
  groupadd -g 888 gns3 &&\
  useradd -d /home/gns3 -g 888 -u 888 -m -s /bin/bash gns3 &&\
  echo gns3:gns3 | chpasswd &&\
  chown 888:888 /home/gns3 && chmod g+s /home/gns3 &&\
  usermod -aG sudo gns3 &&\
  mkdir /var/run/sshd &&\
  ssh-keygen -A
USER gns3
WORKDIR /home/gns3
RUN mkdir .ssh && ssh-keygen -t rsa -C "gns3" -f ".ssh/id_rsa" -P "" &&\
  chmod 700 .ssh &&\
  echo "ifconfig" > /home/gns3/.start.sh &&\
  echo "echo \"-----BEGIN OPENSSH PRIVATE KEY-----\" > /home/gns3/.ssh/id_gns3" >> /home/gns3/.start.sh &&\
  echo "echo \$GITPRIVKEY >> /home/gns3/.ssh/id_gns3" >> /home/gns3/.start.sh &&\
  echo "echo \"-----END OPENSSH PRIVATE KEY-----\" >> /home/gns3/.ssh/id_gns3" >> /home/gns3/.start.sh &&\
  echo "chmod 600 /home/gns3/.ssh/id_gns3" >> /home/gns3/.start.sh &&\
  echo "git config --global user.name \$GITNAME" >> /home/gns3/.start.sh &&\
  echo "git config --global user.email \$GITEMAIL" >> /home/gns3/.start.sh &&\
  echo "git config --global core.sshCommand \"/usr/bin/ssh -i /home/gns3/.ssh/id_gns3\"" >> /home/gns3/.start.sh &&\
  echo "echo \"Host github.com\\\n\\\tStrictHostKeyChecking no\\\n\" >> ~/.ssh/config" >> /home/gns3/.start.sh &&\
  echo "git clone -q \$GITREPO" >> /home/gns3/.start.sh &&\
  echo "echo gns3 | sudo -S /usr/sbin/sshd -D -e" >> /home/gns3/.start.sh &&\
  chmod 755 /home/gns3/.start.sh
EXPOSE 22
ENTRYPOINT "/home/gns3/.start.sh"
