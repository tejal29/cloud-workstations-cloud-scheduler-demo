#!/bin/bash

set -e

if [ $# -ne 4 ]
then
    echo "Usage: update_config.sh CLUSTER REGION CONFIG_KEY VALUE"
    exit 1
fi

CLUSTER=$1
REGION=$2
CONFIG_KEY=$3
VALUE=$4

function update_config {
    # list workstation configs
    echo "Attempting to list workstation configs in cluster $CLUSTER and region $REGION ..."
    for CONFIG in $(gcloud  workstations configs list --cluster $CLUSTER --region $REGION --format="value(NAME)"); do
        echo "Attempting to update $CONFIG_KEY to $VALUE for config $CONFIG ..."
        # update $CONFIG_KEY to $VALUE
        RET=$(gcloud workstations configs update $CONFIG --cluster $CLUSTER  --region $REGION --$CONFIG_KEY=$VALUE)
        if [[ $RET -eq 0 ]]; then
            echo "Workstation config $CONFIG $CONFIG_KEY updated to $VALUE."
        else
            echo "Workstation config $CONFIG update failed."
        fi
    done
}

update_config

exit 0