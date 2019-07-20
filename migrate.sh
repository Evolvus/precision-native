#!/bin/bash

if [[ ( "$#" -gt 2 ) ]]; then
  echo "Usage: $0 [simulation-mode-true-false] [simulation-sleep-time-in-seconds]"
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

function banner() {
  clear
  echo "****************************************************************"
  echo "                                                                "
  echo "                  Precision 100 Execution                       "
  echo "                                                                "
  echo "  Project Name: $PRECISION100_PROJECT_NAME                      "
  echo "                                                                "
  echo "  Iteration: $PRECISION100_EXECUTION_NAME                       "
  echo "                                                                "
  echo "  Operation Mode: $PRECISION100_RUNTIME_EXECUTION_MODE          "
  echo "                                                                "
  echo "  Simulation Mode: $PRECISION100_RUNTIME_SIMULATION_MODE        "
  echo "                                                                "
  echo "                                                                "
  echo "****************************************************************"
}

function pause_banner() {
  echo ".."
  sleep 1
  echo "...."
  sleep 1
  echo "......"
  sleep 1
  echo "........"
  sleep 1
  echo "......"
  sleep 1
  echo "...."
  sleep 1
  echo ".."
  sleep 1
}

export PRECISION100_RUNTIME_EXECUTION_MODE=${1:-"PROD"}
export PRECISION100_RUNTIME_SIMULATION_MODE=${1:-"FALSE"}

export OPERATION="migrate.sh"

declare -a menu_order
declare -A menu_texts
declare -A lines

while read line
do
   key=$( echo $line | cut -d ',' -f 1 )
   value=$( echo $line | cut -d ',' -f 2 )
   menu_order+=( "$key" )
   menu_texts["$key"]="$value"
   lines["$key"]="$line"
done < <($PRECISION100_BIN_FOLDER/get-dataflows.sh)

#DATAFLOW_FILES=$($PRECISION100_BIN_FOLDER/get-dataflows.sh)
DATAFLOW_FILES=${!menu_map[@]}

function ask_question() {
  local log_size="$(wc -c < "$1")"
  local err_size="$(wc -c < "$2")"

  if [[ "PROD" = "$OPERATION_MODE" ]]; then 
    pause_banner
  fi

  while true 
  do 
    banner
    echo "Log file of size $log_size: $1 created"
    echo "Err file of size $err_size: $2 created"
    echo "Would you like to view the log file(s) ?"
    select yn in "Log file" "Err file" "Back to Menu"; do
      case $yn in
        "Log file") 
          vi $1
	  break;;
        "Err file") 
	  vi $2
	  break;;
        "Back to Menu") 
	  return;
      esac
    done
  done
}

function main_loop() {
  banner
  select i in "${menu_order[@]}" "Quit";
  do
    case $i in 
      "Quit")
         exit;
      ;;
      *)
	log_file_name="$PRECISION100_EXECUTION_LOG_FOLDER/${menu_texts[${i%.*}]}-$(date +%F-%H-%M-%S).out"
	err_file_name="$PRECISION100_EXECUTION_LOG_FOLDER/${menu_texts[${i%.*}]}-$(date +%F-%H-%M-%S).err"
        $PRECISION100_BIN_FOLDER/exec-dataflow.sh "${lines[${i%.*}]}" 1> >(tee -a "$log_file_name") 2> >(tee -a "$err_file_name" >&2)
	if [ "$?" -ne "0" ] && [ "$PRECISION100_RUNTIME_EXECUTION_MODE" = "PROD" ]; then
	   echo "Error executing dataflow: $i" 1> >(tee -a "err_file_name")
	   exit 1
	fi

	ask_question "${log_file_name}" "${err_file_name}"
	break;;
    esac;
  done;
}

while true
do
   main_loop;
done
