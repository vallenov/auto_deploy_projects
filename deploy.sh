#!/bin/bash

#Обязательно добавить все проекты в список безопасных репозиториев
#sudo git config --global --add safe.directory /home/vladimir/prog/python/projects/name_of_repo

PROJECTS_DIR=/home/vladimir/prog/python/projects

#Имена проекта и демона могут отличаться, главное - соблюдать порядок
PROJECT_NAME_LIST=(TBot MessageSender system-monitor)
DAEMON_NAME_LIST=(TBot MailSender system_monitor)

DL=$PROJECTS_DIR/deploy.log

function log {
    echo `date` - $1 >> $DL
}

function deploy_project {
if [[ $# == 2 ]]
then
    cd $PROJECTS_DIR/$1
    IS_UPDATE=`git pull`
    if [[ $IS_UPDATE == "Already up to date." ]]
    then
        :
    else
        log "Check update for $1"
        log "Update found"
        if [[ `ls requirements.txt` != "" ]]
        then
            . ./.venv/bin/activate && log "activate venv"
            ./.venv/bin/pip install -r requirements.txt && log "install requirements"
            deactivate && log "deactivate venv"
        fi
        systemctl restart $2.service && log "restart $2.service"
        log "$1 is updated"
    fi
fi
}

for ind in ${!PROJECT_NAME_LIST[*]}
do
    deploy_project ${PROJECT_NAME_LIST[$ind]} ${DAEMON_NAME_LIST[$ind]}
done
