cat dockerpass.txt | docker login --username jrmd24 --password-stdin
#sudo docker build -t streamlit .
sudo systemctl restart docker
yes | sudo docker-compose pull
yes | sudo docker-compose up -d

#sudo docker run -d --restart unless-stopped -p 8501:8501 streamlit &