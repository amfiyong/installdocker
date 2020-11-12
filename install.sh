#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Check system
check_sys(){
    local checkType=$1
    local value=$2

    local release=''
    local systemPackage=''

    if [[ -f /etc/redhat-release ]]; then
        release="centos"
        systemPackage="yum"
    elif grep -Eqi "debian|raspbian" /etc/issue; then
        release="debian"
        systemPackage="apt"
    elif grep -Eqi "ubuntu" /etc/issue; then
        release="ubuntu"
        systemPackage="apt"
    elif grep -Eqi "centos|red hat|redhat" /etc/issue; then
        release="centos"
        systemPackage="yum"
    elif grep -Eqi "debian|raspbian" /proc/version; then
        release="debian"
        systemPackage="apt"
    elif grep -Eqi "ubuntu" /proc/version; then
        release="ubuntu"
        systemPackage="apt"
    elif grep -Eqi "centos|red hat|redhat" /proc/version; then
        release="centos"
        systemPackage="yum"
    fi

    if [[ "${checkType}" == "sysRelease" ]]; then
        if [ "${value}" == "${release}" ]; then
            return 0
        else
            return 1
        fi
    elif [[ "${checkType}" == "packageManager" ]]; then
        if [ "${value}" == "${systemPackage}" ]; then
            return 0
        else
            return 1
        fi
    fi
}

# Get version
getversion(){
    if [[ -s /etc/redhat-release ]]; then
        grep -oE  "[0-9.]+" /etc/redhat-release
    else
        grep -oE  "[0-9.]+" /etc/issue
    fi
}

# CentOS version
centosversion(){
    if check_sys sysRelease centos; then
        local code=$1
        local version="$(getversion)"
        local main_ver=${version%%.*}
        if [ "$main_ver" == "$code" ]; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}

get_char(){
    SAVEDSTTY=`stty -g`
    stty -echo
    stty cbreak
    dd if=/dev/tty bs=1 count=1 2> /dev/null
    stty -raw
    stty echo
    stty $SAVEDSTTY
}
error_detect_depends(){
    local command=$1
    local depend=`echo "${command}" | awk '{print $4}'`
    echo -e "[${green}Info${plain}] Starting to install package ${depend}"
    ${command} > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "[${red}Error${plain}] Failed to install ${red}${depend}${plain}"
        echo "Please visit: https://teddysun.com/486.html and contact."
        exit 1
    fi
}

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
    echo "install end"
    echo
}    