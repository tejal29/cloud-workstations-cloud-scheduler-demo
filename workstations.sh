#!/bin/bash

set -e

if [ $# -ne 3 ]
then
    echo "Usage: workstations.sh OPERATION CLUSTER REGION"
    exit 1
fi

OPERATION=$1
CLUSTER=$2
REGION=$3

function workstations {
    OPERATION=$1
    # list workstation configs
    echo "Attempting to list workstation configs in cluster $CLUSTER and region $REGION ..."
    for CONFIG in $(gcloud  workstations configs list --cluster $CLUSTER --region $REGION --format="value(NAME)"); do
        echo "Attempting to list workstations with config $CONFIG ..."
        # list workstations
        for WORKSTATION in $(gcloud  workstations list --config $CONFIG --cluster $CLUSTER --region $REGION --format="value(NAME)"); do
            echo "Attempting to $OPERATION workstation $WORKSTATION..."
            RET=$(gcloud  workstations $OPERATION $WORKSTATION --cluster $CLUSTER --config $CONFIG --region $REGION)
            if [[ $RET -eq 0 ]]; then
               echo "Workstation $WORKSTATION started."
            else
               echo "Workstation $WORKSTATION start operation failed with error."
            fi
        done
    done
}

if [ "$OPERATION" == "start" ]; then
  workstations start
elif [ "$OPERATION" == "stop" ]; then
  workstations stop
else 
  echo "invalid opertation $OPERATION. Should be one of ["start", "stop"]."
fi

exit 0