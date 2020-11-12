# install docker and docker-compose
install_docker(){
    echo -e "Starting Installing Docker"
    curl -fsSL https://get.docker.com -o get-docker.sh
    bash get-docker.sh
    echo -e "Starting Installing Docker Compose"
    curl -L https://github.com/docker/compose/release/download/1.17.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    curl -L https://raw.githubusercontent.com/docker/compose/1.8.0/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
    clear
    echo install end
    echo
}    