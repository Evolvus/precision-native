#!/bin/bash

source ./conf/.project.env.sh
source $PRECISION100_FOLDER/conf/.env.sh

EXECUTION_NAME=$(cat "$PRECISION100_PROJECT_CONF_FOLDER/.execution.pid")
source "$PRECISION100_PROJECT_CONF_FOLDER/$EXECUTION_NAME.env.sh"

source $PRECISION100_FOLDER/conf/.execution.env.sh

if [ ! -z "$1" ]; then
    export OPERATION_MODE="PROD"
fi
if [ ! -z "$2" ]; then
    export SIMULATION_MODE="TRUE"
fi

$PRECISION100_BIN_FOLDER/install-connect-operator.sh $1 3

