#!/bin/bash

# import utils
. utils.sh

CHANNEL_NAME="$1"
DELAY="$2"
LANGUAGE="$3"
TIMEOUT="$4"
VERBOSE="$5"
: ${CHANNEL_NAME:="info-channel"}
: ${DELAY:="3"}
: ${LANGUAGE:="golang"}
: ${TIMEOUT:="10"}
: ${VERBOSE:="true"}

COUNTER=1
MAX_RETRY=10
LANGUAGE=$(echo "$LANGUAGE" | tr [:upper:] [:lower:])

echo "Channel name : "$CHANNEL_NAME

createChannel() {
	setGlobals 0 "Government"

	if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
		set -x
		peer channel create -o orderer.order.com:7050 -c $CHANNEL_NAME -f $FIXTURES_PATH/channel-artifacts/${CHANNEL_NAME}.tx >&log.txt
		res=$?
		set +x
	else
		set -x
		peer channel create -o orderer.order.com:7050 -c $CHANNEL_NAME -f $FIXTURES_PATH/channel-artifacts/${CHANNEL_NAME}.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA >&log.txt
		res=$?
		set +x
	fi
	cat log.txt
	verifyResult $res "Channel creation failed"
	echo "===================== Channel '$CHANNEL_NAME' created ===================== "
	echo
}

joinChannel() {
	for org in "Government" "Public"; do
		for peer in 0; do
			joinChannelWithRetry $peer $org
			echo "===================== peer${peer}.org${org} joined channel '$CHANNEL_NAME' ===================== "
			sleep $DELAY
			echo
		done
	done
}

## Create channel
echo "Creating channel..."
createChannel

## Join all the peers to the channel
echo "Having all peers join the channel..."
joinChannel

## Set the anchor peers for each org in the channel
echo "Updating anchor peers for Public..."
updateAnchorPeers 0 "Public"
echo "Updating anchor peers for Government..."
updateAnchorPeers 0 "Government"