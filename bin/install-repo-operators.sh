#!/bin/bash

function usage() {
  echo "Usage: $0 <folder where the operators are downloaded> <operator name> "
  echo "e.g. $0 /home/dell/precision100-operators sql"
}

if [[ ( "$#" -ne 2 ) ]]; then
  usage
  exit 1
fi

if [ ! -f ./conf/.project.env.sh ]; then
   echo "Misconfigured installation - missing files in conf directory"
   exit 10
fi
source ./conf/.project.env.sh

if [ -z "$PRECISION100_FOLDER" ] || [ ! -f $PRECISION100_FOLDER/conf/.env.sh ]; then
   echo "Misconfigured installation - Invalid Precision100 installation"
   exit 10
fi
source $PRECISION100_FOLDER/conf/.env.sh

$PRECISION100_BIN_FOLDER/install-repo-operator.sh $1 $2

