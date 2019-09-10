#!/bin/bash

if [[ ( "$#" -gt 0 ) ]]; then
  echo "Usage: $0 "
  echo "e.g. $0 "
  exit 1;
fi

if [ ! -f ./conf/.project.env.sh ]; then
   echo "Misconfigured installation - missing files in conf directory"
   exit 10
fi

source ./conf/.project.env.sh
if [ ! -f "$PRECISION100_PROJECT_CONF_FOLDER/.execution.pid" ]; then
  echo "Iteration not initialized, please initialize the iteration by running init-exec.sh"
  exit 10
fi

if [ -z "$PRECISION100_FOLDER" ] || [ ! -f $PRECISION100_FOLDER/conf/.env.sh ]; then
   echo "Misconfigured installation - Invalid Precision100 installation"
   exit 10
fi


source $PRECISION100_FOLDER/conf/.env.sh

EXECUTION_NAME=$(cat "$PRECISION100_PROJECT_CONF_FOLDER/.execution.pid")
source "$PRECISION100_PROJECT_CONF_FOLDER/$EXECUTION_NAME.env.sh"

source $PRECISION100_FOLDER/conf/.execution.env.sh

echo "Refeshing iteration: ${EXECUTION_NAME}"
$PRECISION100_FOLDER/bin/refresh-exec.sh 
if [ "$?" -ne 0 ]; then
   echo "Iteration refresh had an issue "
   exit 1
fi
