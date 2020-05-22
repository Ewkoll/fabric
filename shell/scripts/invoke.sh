#!/bin/bash

# import utils
. utils.sh

CHAINCODE_NAME="$1"
CC_SRC_PATH="$2"
VERSION="$3"
LANGUAGE="$4"
CHANNEL_NAME="$5"
VERBOSE="$6"
: ${CHAINCODE_NAME:="mycc"}
: ${CC_SRC_PATH:="github.com/chaincode/chaincode_example02/go/"}
: ${CHANNEL_NAME:="info-channel"}
: ${DELAY:="3"}
: ${LANGUAGE:="golang"}
: ${TIMEOUT:="10"}
: ${VERBOSE:="false"}
: ${VERSION:="1.0"}

LANGUAGE=$(echo "$LANGUAGE" | tr [:upper:] [:lower:])
COUNTER=1
MAX_RETRY=10
DELAY=3
TIMEOUT=10

echo "Channel name : "$CHANNEL_NAME

echo "Sending invoke transaction on peer0.public peer0.government..."
chaincodeInvoke 0 "Public" 0 "Government"
