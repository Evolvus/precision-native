#!/bin/bash


function usage() {
  echo "Usage: $0 <iteration name>"
  echo "e.g. $0 mock1"
}

if [[ ( "$#" -ne 1 ) ]]; then
  usage
  exit 1
fi

INPUT_EXECUTION_NAME=$1

if [ -z "${INPUT_EXECUTION_NAME}" ]; then
    usage
    exit 1
fi

if [ ! -f ./conf/.project.env.sh ]; then
   echo "Misconfigured installation - missing files in conf directory"
   exit 10
fi

source ./conf/.project.env.sh

if [ ! -f $PRECISION100_PROJECT_CONF_FOLDER/.env.sh ]; then
   echo "Misconfigured installation - Invalid Precision100 installation"
   exit 10
fi

source $PRECISION100_PROJECT_CONF_FOLDER/.env.sh

EXECUTION_PID_FILE="$PRECISION100_PROJECT_CONF_FOLDER/.execution.pid"

if [ ! -f "$EXECUTION_PID_FILE" ]; then
    echo "Cannot close iteration. No executing iteration identified"
    exit 10
fi

PRECISION100_EXECUTION_NAME=$(cat $EXECUTION_PID_FILE)

if [ ! $INPUT_EXECUTION_NAME = $PRECISION100_EXECUTION_NAME ]; then
    echo "Currently executing $PRECISION100_EXECUTION_NAME. Cannot close $INPUT_EXECUTION_NAME"
    exit 10
fi

read -p "Closing iteration $INPUT_EXECUTION_NAME. Please confirm (y/n) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    ## Just deleting PID file for now
    rm -f $EXECUTION_PID_FILE
fi


