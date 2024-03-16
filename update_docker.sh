#!/bin/sh
if grep -Fqe "Image is up to date" << EOF
`sudo docker pull jrmd24/dit_docker_2024:latest`
EOF
then
    echo "no update, just do cleaning"
    yes | sudo docker system prune --force
    yes | sudo docker system prune --volumes --force
else
    echo "New app version detected, recompose !"
    yes | sudo docker stop $(docker ps -a -q)
    yes | sudo docker rm $(docker ps -a -q)
    #docker-compose down --volumes
    yes | sudo docker-compose -f /home/vagrant/docker-compose.yml up -d
fi