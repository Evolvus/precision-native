#!/bin/bash

CHANNEL="PRECISION-NATIVE"
DEFAULT_PRECISION_NATIVE_HOME=$HOME/simple-demo
DEFAULT_PRECISION100_HOME=$(pwd)/precision100
DEFAULT_REPO_TYPE="GIT"
DEFAULT_REPO_URL="git@github.com:ennovatenow/precision-100-migration-templates.git"
DEFAULT_PROJECT_NAME=simple-demo
DEFAULT_PROJECT_REPO_FOLDER="."

PRECISION100_PROJECT_FOLDER=$(pwd)

PRECISION100_NATIVE_VERSION=$(cat VERSION)

function usage() {
  echo "Usage: $0 <repo type> <repo url> <project name>"
  echo "e.g. $0 GIT \"git@github.com:ennovatenow/precision-100-migration-templates.git\" \"A simple demo\""
}

function report() {
  echo ".."
  sleep 1
  echo "...."
  sleep 1
  echo "Created folder: $PRECISION100_PROJECT_FOLDER/conf"
  echo "Added configuration file: $PRECISION100_PROJECT_FOLDER/conf/.project.env.sh"
  echo "Added default connection file: $PRECISION100_PROJECT_FOLDER/conf/.connections.env.sh"
  echo "Configuration completed.."
}

function banner() {
  clear
  echo "************************************************************************"
  echo "                                                                        "
  echo "             Precision Native($PRECISION100_NATIVE_VERSION)                                      "
  echo "                                                                        "
  echo "  A command-line menu driven interface for the PRECISION100 framework.  "
  echo "                                                                        "
  echo "  Project folder: $PRECISION100_PROJECT_FOLDER                          "
  echo "                                                                        "
  echo "  PRECISION100 VERSION: $PRECISION100_VERSION                           "
  echo "                                                                        "
  echo "************************************************************************"
  echo "                                                                        "
}

function ask_repo_type_qn() {
  echo "                                                                        "
  echo "Provide the type of the repository to be used for the migration templates "
  read -p "Supported values are GIT | FILE. Default[$DEFAULT_REPO_TYPE] : " INPUT_REPO_TYPE
  PRECISION100_PROJECT_REPO_TYPE="${INPUT_REPO_TYPE:-$DEFAULT_REPO_TYPE}"
}

function ask_repo_url_qn() {
  echo "                                                                        "
  echo "URL of the repository for migration templates.                          "
  echo "URL format must match the Repository type chosen above                  "
  read -p "[$DEFAULT_REPO_URL] " INPUT_REPO_URL
  PRECISION100_PROJECT_REPO_URL="${INPUT_REPO_URL:-$DEFAULT_REPO_URL}"
}

function ask_project_name_qn() {
  echo "                                                                        "
  echo "Project Name of the migration template to be used.                      "
  read -p "[simple-demo]" INPUT_PROJECT_NAME
  PRECISION100_PROJECT_NAME="${INPUT_PROJECT_NAME:-$DEFAULT_PROJECT_NAME}"
}

if [[ ( "$#" -gt 3 ) ]]; then
  usage
  exit 1
fi

# Check if python3 is installed
if ! command -v python3 &>/dev/null; then
  echo "python3 is not installed. Please install python3 to proceed."
  exit 1
fi

# Check if python3 version is at least 3.8
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
REQUIRED_VERSION="3.8"

if [[ $(echo -e "$PYTHON_VERSION\n$REQUIRED_VERSION" | sort -V | head -n1) != "$REQUIRED_VERSION" ]]; then
  echo "Python version 3.8 or above is required. Installed version is $PYTHON_VERSION."
  exit 1
fi


# Check if precision_100 package is installed
if ! python3 -c "import p100" &>/dev/null; then
  echo "precision_100 package is not installed. Please install it to proceed."
  exit 1
fi

PRECISION100_VERSION=$(python -c "from importlib.metadata import version;  print(version('precision-100'))")

banner
PRECISION100_FOLDER=$(pwd)/precision100

if [ -f "$PRECISION100_PROJECT_FOLDER/conf/.project.env.sh" ]; then
  echo "Project already initialized..aborting"
  exit 1
fi

if [ -z "$1" ]; then
  ask_repo_type_qn
else
  PRECISION100_PROJECT_REPO_TYPE="$1"
fi

if [ "$PRECISION100_PROJECT_REPO_TYPE" != "GIT" ] && [ "$PRECISION100_PROJECT_REPO_TYPE" != "SVN" ] && [ "$PRECISION100_PROJECT_REPO_TYPE" !=  "FILE" ]; then
  usage
  exit 1
fi

if [ -z "$2" ]; then
  ask_repo_url_qn
else
  PRECISION100_PROJECT_REPO_URL="$2"
fi

if [ -z "$3" ]; then
  ask_project_name_qn
else
  PRECISION100_PROJECT_NAME="$3"
fi

if [ ! -d "$PRECISION100_PROJECT_FOLDER/conf" ]; then
  mkdir -p "$PRECISION100_PROJECT_FOLDER/conf"
fi

if [ ! -f "$PRECISION100_PROJECT_FOLDER/conf/.connections.env.sh" ]; then
  echo "PRECISION100_CONNECTION,ORACLE,USERNAME,PASSWORD,SID" > $PRECISION100_PROJECT_FOLDER/conf/.connections.env.sh
fi

cat > $PRECISION100_PROJECT_FOLDER/conf/.project.env.sh << PROJECT_ENV
export PRECISION100_FOLDER="$PRECISION100_FOLDER"
export PRECISION100_PROJECT_FOLDER="$PRECISION100_PROJECT_FOLDER"
export PRECISION100_PROJECT_REPO_TYPE="$PRECISION100_PROJECT_REPO_TYPE"
export PRECISION100_PROJECT_REPO_URL="$PRECISION100_PROJECT_REPO_URL"
export PRECISION100_PROJECT_NAME="$PRECISION100_PROJECT_NAME"
export PRECISION100_PROJECT_REPO_FOLDER="$PRECISION100_PROJECT_REPO_FOLDER"
export PRECISION100_PROJECT_CONF_FOLDER="$PRECISION100_PROJECT_FOLDER/conf"
export PRECISION100_PROJECT_CONNECTION_FILE="$PRECISION100_PROJECT_FOLDER/conf/.connections.env.sh"
export PRECISION100_PROJECT_DEFAULT_CONNECTION="PRECISION100_CONNECTION"
export PRECISION100_RUNTIME_EXECUTION_MODE="DEV"
export PRECISION100_RUNTIME_SIMULATION_MODE="FALSE"
export PRECISION100_RUNTIME_SIMULATION_SLEEP=1
export CHANNEL="$CHANNEL"
PROJECT_ENV

report
