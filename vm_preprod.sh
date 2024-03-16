#!/bin/bash
yes | sudo apt-get update

yes | sudo apt-get remove docker docker-engine docker.io containerd runc

yes | sudo rm -rf /var/lib/docker
yes | sudo rm -rf /var/lib/containerd

yes | sudo apt-get update  
yes | sudo apt-get upgrade

yes | sudo apt install cron
yes | sudo systemctl enable cron

if [[ !(-z "$ENABLE_ZSH")  &&  ($ENABLE_ZSH == "true") ]]
then
    echo "INFO : Installer zsh"
    sudo apt install zsh git
    echo "vagrant" | chsh -s /bin/zsh vagrant
    su - vagrant  -c  'echo "Y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
    su - vagrant  -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    sed -i 's/^plugins=/#&/' /home/vagrant/.zshrc
    echo "plugins=(git  docker docker-compose colored-man-pages aliases copyfile  copypath dotenv zsh-syntax-highlighting jsontools)" >> /home/vagrant/.zshrc
    sed -i "s/^ZSH_THEME=.*/ZSH_THEME='agnoster'/g"  /home/vagrant/.zshrc
  else
    echo "ERROR : zsh n'est pas installe sur le serveur"    
fi

yes | sudo apt-get install ca-certificates curl gnupg lsb-release dirmngr software-properties-common apt-transport-https
yes | curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg > /dev/null

yes | sudo chmod a+r /usr/share/keyrings/docker.gpg

yes | echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

yes | sudo apt-get update
yes | sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
yes | sudo apt-get install docker-compose

systemctl status docker.service
yes | sudo systemctl start docker.service
yes | sudo systemctl enable docker.service

yes | sudo rm -rf /etc/ssh/sshd_config.d/*
sudo service ssh restart

sudo mkdir /var/job
sudo chown -R vagrant /var/job

#yes | sudo chmod 0600 users.txt
#yes | sudo newusers users.txt
yes | sudo adduser --disabled-password --gecos "" jrmd
yes | sudo echo "jrmd:ditpass" | chpasswd

yes | sudo usermod -aG docker vagrant
yes | sudo usermod -aG sudo jrmd
yes | sudo usermod -aG docker jrmd
#newgrp docker
#docker version
