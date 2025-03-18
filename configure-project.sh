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

function install_package() {
  if [ "${1}" == "PYPI" ]; then
     python3 -m pip -q install "$2"
     return $?
  fi
  if [ "${1}" == "TESTPYPI" ]; then
     python3 -m pip -q install --index-url https://test.pypi.org/simple "${2}" 
     return $?
  fi
  package_name=$(echo $2 | tr -s '-' '_')
  python3 -m pip -q install ${1}/${package_name}*
  return $?
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

# Check if python3 version is at least 3.11
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
REQUIRED_VERSION="3.11"

if [[ $(echo -e "$PYTHON_VERSION\n$REQUIRED_VERSION" | sort -V | head -n1) != "$REQUIRED_VERSION" ]]; then
  echo "Python version 3.11 or above is required. Installed version is $PYTHON_VERSION."
  exit 1
fi

echo "Checking if virtual env has been created"
if [[ ! -f "./dev/pyvenv.cfg" ]] ; then
  echo "Virtual environment not created"
  echo "Creating virtual environment"
  python3 -m venv dev
else
  echo "virtual env created"
fi
source ./dev/bin/activate

echo "Checking PRECISION_PACKAGE_REPOSITORY value"
if [ -z "${PRECISION_PACKAGE_REPOSITORY}" ] ; then
  echo "PRECISION_PACKAGE_REPOSITORY value not set defaulting to PYPI"
  PRECISION_PACKAGE_REPOSITORY="PYPI"
fi
if [ "${PRECISION_PACKAGE_REPOSITORY}" != "PYPI" ] && [ "${PRECISION_PACKAGE_REPOSITORY}" != "TESTPYPI" ] && [ ! -d "${PRECISION_PACKAGE_REPOSITORY}" ] ; then
  echo "Only PYPI, TESTPYPI and path to folder are supported values for PRECISION_PACKAGE_REPOSITORY"
  exit 1
fi 

echo "Checking dependencies"

echo "Checking Precision 100"
# Check if precision_100 package is installed
if ! python3 -c "import p100" &>/dev/null; then
  echo "precision_100 package is not installed. "
  echo "attempting to install precision_100 package from ${PRECISION_PACKAGE_REPOSITORY}"
  install_package "${PRECISION_PACKAGE_REPOSITORY}" "precision-100"
  result="$?"
  if [ "$result" -ne 0 ]; then
     echo "Unable to install precision_100, exiting.."
     exit $result;
  fi
fi

echo "Checking Precision 100 Operators"
# Check if precision_100_operators package is installed
if ! python3 -c "import p100.operator.repo" &>/dev/null; then
  echo "precision_100_operator package is not installed. "
  echo "attempting to install precision_100 package from ${PRECISION_PACKAGE_REPOSITORY}"
  install_package "${PRECISION_PACKAGE_REPOSITORY}" "precision-100-operators"
  result="$?"
  if [ "$result" -ne 0 ]; then
     echo "Unable to install precision_100_operators, exiting.."
     exit $result;
  fi
fi

echo "Checking cryptography"
# Check if cryptography package is installed
if ! python3 -c "from cryptography.fernet import Fernet" &>/dev/null; then
  echo "cryptography package is not installed. You will not be able to encrypt secrets".
  echo "Recommeded to install the package and encrypt all secrets"
  echo "attempting to install cryptography package from ${PRECISION_PACKAGE_REPOSITORY}"
  install_package "${PRECISION_PACKAGE_REPOSITORY}" "cryptography"
  result="$?"
  if [ "$result" -ne 0 ]; then
     echo "Unable to install cryptography, exiting.."
     echo "cryptography package is not installed. You will not be able to encrypt secrets".
  fi
fi

#Check if orcl package is installed
if ! python3 -c "import p100.operator.orcl" &>/dev/null; then
  echo "orcl package is not installed."
  echo "attempting to install orcl package from ${PRECISION_PACKAGE_REPOSITORY}"
  install_package "${PRECISION_PACKAGE_REPOSITORY}" "precision-100-orcl-operators"
  result="$?"
  if [ "$result" -ne 0 ]; then
     echo "Unable to install precision_100_orcl_operators, exiting.."
     exit $result;
  fi
fi

echo "Dependecy check completed."

PRECISION100_VERSION=$(python -c "from importlib.metadata import version;  print(version('precision-100'))")
echo "Found Precision 100 $PRECISION100_VERSION version"

PRECISION100_OPERATOR_VERSION=$(python -c "from importlib.metadata import version;  print(version('precision-100-operators'))")
echo "Found Precision 100 Operator $PRECISION100_OPERATOR_VERSION version"

CRYPTOGRAPHY_VERSION=$(python -c "from importlib.metadata import version;  print(version('cryptography'))")
echo "Found cryptography $CRYPTOGRAPHY_VERSION version"

PRECISION100_ORCL_OPERATOR_VERSION=$(python -c "from importlib.metadata import version;  print(version('precision-100-orcl-operators'))")
echo "Found Precision 100 Orcle Operator $PRECISION100_ORCL_OPERATOR_VERSION version"

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
if [ ! -d "$PRECISION100_PROJECT_FOLDER/log" ]; then
  mkdir -p "$PRECISION100_PROJECT_FOLDER/log"
fi
if [ ! -d "$PRECISION100_PROJECT_FOLDER/output" ]; then
  mkdir -p "$PRECISION100_PROJECT_FOLDER/output"
fi
if [ ! -d "$PRECISION100_PROJECT_FOLDER/output" ]; then
  mkdir -p "$PRECISION100_PROJECT_FOLDER/temp"
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
export PRECISION100_PROJECT_LOG_FOLDER="$PRECISION100_PROJECT_FOLDER/log"
export PRECISION100_PROJECT_OUTPUT_FOLDER="$PRECISION100_PROJECT_FOLDER/output"
export PRECISION100_PROJECT_CONNECTION_FILE="$PRECISION100_PROJECT_FOLDER/conf/.connections.env.sh"
export PRECISION100_PROJECT_DEFAULT_CONNECTION="PRECISION100_CONNECTION"
export PRECISION100_RUNTIME_EXECUTION_MODE="DEV"
export PRECISION100_RUNTIME_SIMULATION_MODE="FALSE"
export PRECISION100_RUNTIME_SIMULATION_SLEEP=1
export CHANNEL="$CHANNEL"
PROJECT_ENV

report
