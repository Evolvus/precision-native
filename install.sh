#!/bin/bash

CHANNEL="PRECISION-NATIVE"
DEFAULT_PRECISION_NATIVE_HOME=$HOME/simple-demo
DEFAULT_PRECISION100_HOME=$HOME/precision100
DEFAULT_REPO_TYPE="GIT"
DEFAULT_REPO_URL="git@github.com:ennovatenow/precision-100-migration-templates.git"
DEFAULT_PROJECT_NAME=simple-demo

PRECISION100_PROJECT_FOLDER=$(pwd)

function banner() {
  clear
  echo "************************************************************************"
  echo "                                                                        "
  echo "                  Precision Native                                      "
  echo "                                                                        "
  echo "  A command-line menu driven interface for the PRECISION100 framework.  "
  echo "                                                                        "
  echo "************************************************************************"
  echo "                                                                        "
}
banner
#echo "Location where you want Precision Native installed`: "
#read -p "[$DEFAULT_PRECISION_NATIVE_HOME]: " INPUT_PRECISION_NATIVE_FOLDER
#PRECISION_NATIVE_FOLDER="${INPUT_PRECISION_NATIVE_FOLDER:-$DEFAULT_PRECISION_NATIVE_HOME}"

echo "Location of the PRECISION100 framework installtion: "
read -p "[$DEFAULT_PRECISION100_HOME]: " INPUT_PRECISION100_FOLDER
PRECISION100_FOLDER="${INPUT_PRECISION100_FOLDER:-$DEFAULT_PRECISION100_HOME}"

echo "                                                                        "
echo "Provide the type of the repository to be used for the migration templates "
read -p "Supported values are GIT | FILE. Default[$DEFAULT_REPO_TYPE] : " INPUT_REPO_TYPE
PRECISION100_PROJECT_REPO_TYPE="${INPUT_REPO_TYPE:-$DEFAULT_REPO_TYPE}"

echo "                                                                        "
echo "URL of the repository for migration templates.                          "
echo "URL format must match the Repository type chosen above                  "
read -p "[$DEFAULT_REPO_URL] " INPUT_REPO_URL
PRECISION100_PROJECT_REPO_URL="${INPUT_REPO_URL:-$DEFAULT_REPO_URL}"

echo "                                                                        "
echo "Project Name of the migration template to be used.                      "
read -p "[simple-demo]" INPUT_PROJECT_NAME
PRECISION100_PROJECT_NAME="${INPUT_PROJECT_NAME:-$DEFAULT_PROJECT_NAME}"

if [ ! -d "$PRECISION100_PROJECT_FOLDER/conf" ]; then
  mkdir -p "$PRECISION100_PROJECT_FOLDER/conf"
fi

touch $PRECISION100_PROJECT_FOLDER/conf/.connections.env.sh

cat > $PRECISION100_PROJECT_FOLDER/conf/.project.env.sh << PROJECT_ENV
export PRECISION100_FOLDER="$PRECISION100_FOLDER"
export PRECISION100_PROJECT_FOLDER="$PRECISION100_PROJECT_FOLDER"
export PRECISION100_PROJECT_REPO_TYPE="$PRECISION100_PROJECT_REPO_TYPE"
export PRECISION100_PROJECT_REPO_URL="$PRECISION100_PROJECT_REPO_URL"
export PRECISION100_PROJECT_NAME="$PRECISION100_PROJECT_NAME"
export PRECISION100_PROJECT_CONF_FOLDER="$PRECISION100_PROJECT_FOLDER/conf"
export PRECISION100_PROJECT_CONNECTION_FILE="$PRECISION100_PROJECT_FOLDER/conf/.connection.env.sh"
export PRECISION100_PROJECT_DEFAULT_CONNECTION="PRECISION100_CONNECTION"
export PRECISION100_PROJECT_OPERATION_MODE="DEV"
export CHANNEL="$CHANNEL"
export SIMULATION_MODE="FALSE"
PROJECT_ENV
