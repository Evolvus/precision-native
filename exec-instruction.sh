#!/bin/bash

if [[ ( "$#" -ne 2 ) ]]; then
  echo "Usage: $0 <Container> <Line Number>"
  echo "e.g. $0 setup 10"
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

export PRECISION100_RUNTIME_EXECUTION_MODE=${1:-"PROD"}
export PRECISION100_RUNTIME_SIMULATION_MODE=${2:-"FALSE"}

export OPERATION="EXEC_INSTRUCTION.sh"

export CONTAINER=$1
LINE=$2

log_file_name="$PRECISION100_EXECUTION_LOG_FOLDER/${CONTAINER}-${LINE}-$(date +%F-%H-%M-%S).out"
err_file_name="$PRECISION100_EXECUTION_LOG_FOLDER/${CONTAINER}-${LINE}-$(date +%F-%H-%M-%S).err"

filelines=$($PRECISION100_BIN_FOLDER/get-files.sh $CONTAINER)

found="FALSE"
for REGISTRY_LINE in $filelines ; do
   index=$(echo $REGISTRY_LINE | cut -d ',' -f 1)
   if [[ "$index" == "$LINE" ]]; then
     $PRECISION100_BIN_FOLDER/exec-file.sh $CONTAINER $REGISTRY_LINE 1> >(tee -a "$log_file_name") 2> >(tee -a "$err_file_name" >&2)
     found="TRUE"
   fi
done

if [[ "$found" == "FALSE" ]]; then
   echo "Invalid Line Number for the container"
   exit 5
fi

