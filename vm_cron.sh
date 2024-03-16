#!/bin/bash
yes | sudo chmod +x /var/job/update_docker.sh

yes | sudo crontab -l > crontab_new 
yes | sudo echo "*/5 * * * * /var/job/update_docker.sh > /var/job/update_docker_job.log 2>&1" >> crontab_new
yes | sudo crontab crontab_new

yes | sudo rm crontab_new

