#!/bin/sh

USAGE="$0 CLUSTER_NAME"
CLUSTER=${1:?usage $USAGE}

SSH_KEY=${SSH_KEY:-"$HOME/.ssh/id_rsa.pub"}
KEY_NAME=${KEY_NAME:-"test"}
INSTANCE_TYPE=${INSTANCE_TYPE:-"t2.small"}
REGION=${REGION:-us-east-1}

test -f $SSH_KEY || {
    mkdir -p -m 0600 $HOME/.ssh
    ssh-add -L | grep -E '^ssh-rsa ' | cut -d' '  -f1,2  > $HOME/.ssh/id_rsa.pub
}

aws ec2 describe-key-pairs --region $REGION \
        --key-names $KEY_NAME 2>&1 > /dev/null \
    || aws ec2 import-key-pair --key-name $KEY_NAME --region $REGION \
       --public-key-material $(cat $SSH_KEY)

ecs-cli up --region $REGION --cluster $CLUSTER --keypair $KEY_NAME \
        --capability-iam --instance-type $INSTANCE_TYPE --size 2

ecs-cli compose --region $REGION --cluster $CLUSTER service up
