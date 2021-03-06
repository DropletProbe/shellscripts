#!/usr/bin/env bash

password=$1
function usage () {
    echo 'Usage : Script <password>'
    exit 1
}

# check whether the necessary parameter is empty or not
if [ "$#" -ne 1 ]
then
    usage
    exit 1
fi

expect <<- DONE
    set timeout -1
    spawn sudo yum -y install openssh-server openssh-clients
    expect "*?assword*"
    send -- "$password\r"
    expect eof
    spawn sudo chkconfig sshd on
    expect "*?assword*"
    send -- "$password\r"
    expect eof
    spawn sudo service sshd start
    expect "*?assword*"
    send -- "$password\r"
    expect eof
DONE


netstat -tulpn | grep :22

ssh-keygen -b 4096 -f $HOME/.ssh/id_rsa -N '' -t rsa

expect <<- DONE
    set timeout -1

    spawn ssh-copy-id -i $HOME/.ssh/id_rsa.pub -o StrictHostKeyChecking=no localhost

    # Look for passwod prompt
    expect "*?assword*"

    # Send password aka $password
    send -- "$password\r"

    expect eof
DONE

# eval "$(ssh-agent -s)"
ssh-add
