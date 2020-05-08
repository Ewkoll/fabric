#!/bin/bash

BASE_PATH=$(cd `dirname $0`; pwd)

HOSTNAME=orderer.order.com
ORDERER_GENERAL_MSP_PATH=${BASE_PATH}/crypto-config/ordererOrganizations/order.com/orderers/orderer.order.com/msp
ORDERER_GENERAL_TLS_PATH=${BASE_PATH}/crypto-config/ordererOrganizations/order.com/orderers/orderer.order.com/tls
FABRIC_CFG_PATH=${BASE_PATH}/../../sampleconfig
CHANNEL_ARTIFACTS=${BASE_PATH}/channel-artifacts
ORDERER_FILELEDGER_LOCATION=${BASE_PATH}/${HOSTNAME}

function order_generate() {
    sed -e "s/\${HOSTNAME}/${1}/" \
        -e "s#\${ORDERER_GENERAL_MSP_PATH}#${2}#" \
        -e "s#\${ORDERER_GENERAL_TLS_PATH}#${3}#" \
        -e "s#\${FABRIC_CFG_PATH}#${4}#" \
        -e "s#\${CHANNEL_ARTIFACTS}#${5}#" \
        -e "s#\${ORDERER_FILELEDGER_LOCATION}#${6}#" \
        .env.orderer.template
}

echo "$(order_generate $HOSTNAME $ORDERER_GENERAL_MSP_PATH $ORDERER_GENERAL_TLS_PATH $FABRIC_CFG_PATH $CHANNEL_ARTIFACTS $ORDERER_FILELEDGER_LOCATION)" > .env.orderer
cp .env.orderer $BASE_PATH/../../orderer/.env
cp .env.orderer $BASE_PATH/../../.build/bin/.env

PEER_HOST=government.peer.com
CORE_PEER_LISTENIP=0.0.0.0
CORE_PEER_LISTENPORT=7051
CORE_PEER_CHAINCODE_LISTENPORT=7052
CORE_OPERATIONS_LISTENADDRESS=${CORE_PEER_LISTENIP}:9443

HOSTNAME=peer0.government.peer.com
CORE_PEER_LISTENADDRESS=${CORE_PEER_LISTENIP}:${CORE_PEER_LISTENPORT}
CORE_PEER_ADDRESS=${HOSTNAME}:${CORE_PEER_LISTENPORT}
CORE_PEER_CHAINCODELISTENADDRESS=${CORE_PEER_LISTENIP}:${CORE_PEER_CHAINCODE_LISTENPORT}
CORE_PEER_CHAINCODEADDRESS=${HOSTNAME}:${CORE_PEER_CHAINCODE_LISTENPORT}
CORE_PEER_GOSSIP_BOOTSTRAP=${HOSTNAME}:${CORE_PEER_LISTENPORT}
CORE_PEER_GOSSIP_ENDPOINT=${HOSTNAME}:${CORE_PEER_LISTENPORT}
CORE_PEER_GOSSIP_EXTERNALENDPOINT=${HOSTNAME}:${CORE_PEER_LISTENPORT}
CORE_PEER_LOCALMSPID=GovernmentMSP

CORE_PEER_FILESYSTEMPATH=${BASE_PATH}/${HOSTNAME}
CORE_PEER_MSP_PATH=${BASE_PATH}/crypto-config/peerOrganizations/${PEER_HOST}/peers/peer0.${PEER_HOST}/msp
CORE_PEER_TLS_PATH=${BASE_PATH}/crypto-config/peerOrganizations/${PEER_HOST}/peers/peer0.${PEER_HOST}/tls

function peer_generate() {
    sed -e "s/\${HOSTNAME}/${1}/" \
        -e "s/\${CORE_PEER_LISTENADDRESS}/${2}/" \
        -e "s/\${CORE_PEER_ADDRESS}/${3}/" \
        -e "s/\${CORE_PEER_CHAINCODELISTENADDRESS}/${4}/" \
        -e "s/\${CORE_PEER_CHAINCODEADDRESS}/${5}/" \
        -e "s/\${CORE_PEER_GOSSIP_BOOTSTRAP}/${6}/" \
        -e "s/\${CORE_PEER_GOSSIP_ENDPOINT}/${7}/" \
        -e "s/\${CORE_PEER_GOSSIP_EXTERNALENDPOINT}/${8}/" \
        -e "s/\${CORE_PEER_LOCALMSPID}/${9}/" \
        -e "s#\${FABRIC_CFG_PATH}#${FABRIC_CFG_PATH}#" \
        -e "s#\${CORE_PEER_FILESYSTEMPATH}#${10}#" \
        -e "s#\${CORE_PEER_MSP_PATH}#${11}#" \
        -e "s#\${CORE_PEER_TLS_PATH}#${12}#" \
        -e "s/\${CORE_OPERATIONS_LISTENADDRESS}/${13}/" \
        .env.peer.template
}

echo "$(peer_generate $HOSTNAME \
                      $CORE_PEER_LISTENADDRESS \
                      $CORE_PEER_ADDRESS \
                      $CORE_PEER_CHAINCODELISTENADDRESS \
                      $CORE_PEER_CHAINCODEADDRESS \
                      $CORE_PEER_GOSSIP_BOOTSTRAP \
                      $CORE_PEER_GOSSIP_ENDPOINT \
                      $CORE_PEER_GOSSIP_EXTERNALENDPOINT \
                      $CORE_PEER_LOCALMSPID \
                      $CORE_PEER_FILESYSTEMPATH \
                      $CORE_PEER_MSP_PATH \
                      $CORE_PEER_TLS_PATH \
                      $CORE_OPERATIONS_LISTENADDRESS)" > .env.government
cp .env.government $BASE_PATH/../../peer_government/.env.government
cp .env.government $BASE_PATH/../../.build/bin/.env.government

PEER_HOST=public.peer.com
CORE_PEER_LISTENIP=0.0.0.0
CORE_PEER_LISTENPORT=8051
CORE_PEER_CHAINCODE_LISTENPORT=8052
CORE_OPERATIONS_LISTENADDRESS=${CORE_PEER_LISTENIP}:9444

HOSTNAME=peer0.public.peer.com
CORE_PEER_LISTENADDRESS=${CORE_PEER_LISTENIP}:${CORE_PEER_LISTENPORT}
CORE_PEER_ADDRESS=${HOSTNAME}:${CORE_PEER_LISTENPORT}
CORE_PEER_CHAINCODELISTENADDRESS=${CORE_PEER_LISTENIP}:${CORE_PEER_CHAINCODE_LISTENPORT}
CORE_PEER_CHAINCODEADDRESS=${HOSTNAME}:${CORE_PEER_CHAINCODE_LISTENPORT}
CORE_PEER_GOSSIP_BOOTSTRAP=${HOSTNAME}:${CORE_PEER_LISTENPORT}
CORE_PEER_GOSSIP_ENDPOINT=${HOSTNAME}:${CORE_PEER_LISTENPORT}
CORE_PEER_GOSSIP_EXTERNALENDPOINT=${HOSTNAME}:${CORE_PEER_LISTENPORT}
CORE_PEER_LOCALMSPID=PublicMSP

CORE_PEER_FILESYSTEMPATH=${BASE_PATH}/${HOSTNAME}
CORE_PEER_MSP_PATH=${BASE_PATH}/crypto-config/peerOrganizations/${PEER_HOST}/peers/peer0.${PEER_HOST}/msp
CORE_PEER_TLS_PATH=${BASE_PATH}/crypto-config/peerOrganizations/${PEER_HOST}/peers/peer0.${PEER_HOST}/tls

echo "$(peer_generate $HOSTNAME \
                      $CORE_PEER_LISTENADDRESS \
                      $CORE_PEER_ADDRESS \
                      $CORE_PEER_CHAINCODELISTENADDRESS \
                      $CORE_PEER_CHAINCODEADDRESS \
                      $CORE_PEER_GOSSIP_BOOTSTRAP \
                      $CORE_PEER_GOSSIP_ENDPOINT \
                      $CORE_PEER_GOSSIP_EXTERNALENDPOINT \
                      $CORE_PEER_LOCALMSPID \
                      $CORE_PEER_FILESYSTEMPATH \
                      $CORE_PEER_MSP_PATH \
                      $CORE_PEER_TLS_PATH \
                      $CORE_OPERATIONS_LISTENADDRESS)" > .env.public
cp .env.public $BASE_PATH/../../peer_public/.env.public
cp .env.public $BASE_PATH/../../.build/bin/.env.public