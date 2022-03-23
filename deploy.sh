#!/bin/bash

PROJECT_DIR=/home/vladimir/prog/python/projects

#Имена проекта и демона могут отличаться, главное - соблюдать порядок
PROJECT_NAME_LIST=(TBot MessageSender system-monitor)
DAEMON_NAME_LIST=(TBot MailSender system_monitor)

DL=$PROJECT_DIR/deploy.log

echo `date` - Start deploy >> $DL

function deploy_project {
if [[ $# == 2 ]]
then
    echo `date` - "Check update for" $1 >> $DL
    cd $PROJECT_DIR/$1
    IS_UPDATE=`git pull`
    if [[ $IS_UPDATE == "Already up to date." ]]
    then
        echo `date` - Already up to date. >> $DL
    else
        echo `date` - Update found >> $DL
        if [[ `ls requirements.txt` != "" ]]
        then
            . ./.venv/bin/activate && echo `date` - activate venv >> $DL
            ./.venv/bin/pip install -r requirements.txt && echo `date` - install requirements >> $DL
            deactivate && echo `date` - deactivate venv >> $DL
        fi
        systemctl restart $2.service && echo `date` - restart $2.service >> $DL
        echo `date` - $1 is updated >> $DL
    fi
fi
}

for ind in ${!PROJECT_NAME_LIST[*]}
do
    deploy_project ${PROJECT_NAME_LIST[$ind]} ${DAEMON_NAME_LIST[$ind]}
done

echo `date` - Deploy is over >> $DL
echo >> $DL