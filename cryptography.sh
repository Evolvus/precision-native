#!/bin/bash

function generate_random_key() {
local exec_result=$(python3 -c "
from p100 import encdec as crypto
key = crypto.generate_key()
print( key )
")
echo "$exec_result"
}

function encrypt() {
local exec_result=$(python3 -c "
from p100 import encdec as crypto
key = crypto.encrypt_value('$1', '$2')
print( key )
")
echo "$exec_result"
}

function decrypt() {
local exec_result=$(python3 -c "
from p100 import encdec as crypto
key = crypto.decrypt_value('$1','$2')
print( key )
")
echo "$exec_result"
}


function usage() {
  echo "Usage: $0 [action] [parameters]"
  echo "Usage: $0 generate_key"
  echo "Usage: $0 encrypt key text_to_be_encrypted"
  echo "Usage: $0 decrypt key text_to_be_decrypted"
}


if [[ ( "$#" -ne 1 ) && ( "$#" -ne 3 )  ]]; then
  usage
  exit 1;
fi

if [[ ( "$#" -eq 1) ]]; then
   if [[ "$1" == "generate_key" ]]; then
      exec_result=$(generate_random_key)
      echo "$exec_result"
      exit 0;
   fi
   usage
   exit 1;
fi

if [[ ( "$#" -eq 3) ]]; then
   if [[ "$1" != "encrypt"  && "$1" != "decrypt" ]]; then
      usage;
      exit 1;
   fi
fi

if [[ ( "$1" == "encrypt" ) ]]; then
   encrypt "$2" "$3"
   exit 0
fi

if [[ ( "$1" == "decrypt" ) ]]; then
   decrypt "$2" "$3"
   exit 0
fi

