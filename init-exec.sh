#!/bin/bash


function usage() {
  echo "Usage: $0 <iteration name>"
  echo "e.g. $0 mock1"
}

function cleanup() {
  rm -f $EXECUTION_PID_FILE
  rm -f $PRECISION100_EXECUTION_CONF_FILE_NAME
  rm -fR $PRECISION100_EXECUTION_FOLDER
}

if [[ ( "$#" -ne 1 ) ]]; then
  usage
  exit 1
fi

DEFAULT_EXECUTION_NAME="mock1"
INPUT_EXECUTION_NAME=${1:-$DEFAULT_EXECUTION_NAME}

if [ -z "${INPUT_EXECUTION_NAME}" ]; then
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

PRECISION100_EXECUTION_NAME=${INPUT_EXECUTION_NAME:-$DEFAULT_EXECUTION_NAME}
EXECUTION_PID_FILE="$PRECISION100_PROJECT_CONF_FOLDER/.execution.pid"

if [ -f "$EXECUTION_PID_FILE" ]; then
    echo "Cannot initialize interation: $PRECISION100_EXECUTION_NAME"
    echo "Already executing iteration: $(cat $EXECUTION_PID_FILE)"
    exit 10
fi
echo $PRECISION100_EXECUTION_NAME > "$EXECUTION_PID_FILE"

PRECISION100_EXECUTION_CONF_FILE_NAME="$PRECISION100_PROJECT_CONF_FOLDER/$PRECISION100_EXECUTION_NAME.env.sh"

if [ -f "$PRECISION100_EXECUTION_CONF_FILE_NAME" ]; then
    echo "Cannot initialize interation: $PRECISION100_EXECUTION_NAME"
    echo "Iteration: $PRECISION100_EXECUTION_NAME already executed" 
    exit 10
fi

PRECISION100_EXECUTION_FOLDER="$PRECISION100_PROJECT_FOLDER/$PRECISION100_EXECUTION_NAME"
cat > "$PRECISION100_EXECUTION_CONF_FILE_NAME" << EOL
export PRECISION100_EXECUTION_NAME="$PRECISION100_EXECUTION_NAME"
export PRECISION100_EXECUTION_FOLDER="$PRECISION100_EXECUTION_FOLDER"
EOL
source "$PRECISION100_EXECUTION_CONF_FILE_NAME"

source "$PRECISION100_CONF_FOLDER/.execution.env.sh"

mkdir -p "$PRECISION100_EXECUTION_LOG_FOLDER"
log_file_name="$PRECISION100_EXECUTION_LOG_FOLDER/init-exec-$(date +%F-%H-%M-%S).out"
err_file_name="$PRECISION100_EXECUTION_LOG_FOLDER/init-exec-$(date +%F-%H-%M-%S).err"

mkdir -p $PRECISION100_EXECUTION_FOLDER

echo "Starting iteration: ${INPUT_EXECUTION_NAME}"
$PRECISION100_FOLDER/bin/init-exec.sh 1> >(tee -a "$log_file_name") 2> >(tee -a "$err_file_name" >&2)
if [ "$?" -ne 0 ]; then
   echo "Iteration start had an issue "
   echo "Cleaning up.."
   cleanup
fi
