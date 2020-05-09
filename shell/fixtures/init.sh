#!/bin/bash

export PATH=${PWD}/../../.build/bin:$PATH
export VERBOSE=true
export FABRIC_CFG_PATH=${PWD} # 设置configtx.yaml文件查找目录。

# 获取将用于为您的平台选择正确的本机二进制文件的操作系统和体系结构字符串，例如darwin-amd64或linux-amd64。
OS_ARCH=$(echo "$(uname -s | tr '[:upper:]' '[:lower:]' | sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')" | awk '{print tolower($0)}')
# 超时持续时间-在放弃之前，CLI应等待来自另一个容器的响应的持续时间。
CLI_TIMEOUT=10
# 默认命令之间的时间延迟。
CLI_DELAY=3
# 系统通道的名称。
SYS_CHANNEL="info-sys-channel"
# 默认通道名称。
CHANNEL_NAME="info-channel"
# 配置文件名称
PROFILE_NAME="CnmdSoloGenesis"
# 通道配置文件名称
PROFILE_CHANNEL_NAME="CnmdChannel"
# 默认链码语言。
LANGUAGE=golang

function generateChannelArtifacts() {
    which configtxgen
    if [ "$?" -ne 0 ]; then
        echo "configtxgen tool not found. exiting"
        exit 1
    fi

    if [ ! -d "./channel-artifacts" ]; then
        mkdir ./channel-artifacts
        touch ./channel-artifacts/.gitkeep
    fi

    echo "##########################################################"
    echo "#########  Generating Orderer Genesis block ##############"
    echo "##########################################################"
    # Note: For some unknown reason (at least for now) the block file can't be
    # named orderer.genesis.block or the orderer will fail to launch!
    set -x
    configtxgen -profile $PROFILE_NAME -channelID $SYS_CHANNEL -outputBlock ./channel-artifacts/genesis.block
    res=$?
    set +x
    if [ $res -ne 0 ]; then
        echo "Failed to generate orderer genesis block..."
        exit 1
    fi
    echo
    echo "#################################################################"
    echo "### Generating channel configuration transaction 'channel.tx' ###"
    echo "#################################################################"
    set -x
    configtxgen -profile $PROFILE_CHANNEL_NAME -outputCreateChannelTx ./channel-artifacts/$CHANNEL_NAME.tx -channelID $CHANNEL_NAME
    res=$?
    set +x
    if [ $res -ne 0 ]; then
        echo "Failed to generate channel configuration transaction..."
        exit 1
    fi
    echo
    echo "#################################################################"
    echo "######  Generating anchor peer update for GovernmentOrg #########"
    echo "#################################################################"
    set -x
    configtxgen -profile $PROFILE_CHANNEL_NAME -outputAnchorPeersUpdate \
        ./channel-artifacts/GovernmentOrgAnchors.tx -channelID $CHANNEL_NAME -asOrg GovernmentOrg
    res=$?
    set +x
    if [ $res -ne 0 ]; then
        echo "Failed to generate anchor peer update for GovernmentOrg..."
        exit 1
    fi
    echo
    echo "#################################################################"
    echo "######   Generating anchor peer update for PublicOrg   ##########"
    echo "#################################################################"
    set -x
    configtxgen -profile $PROFILE_CHANNEL_NAME -outputAnchorPeersUpdate \
        ./channel-artifacts/PublicOrgAnchors.tx -channelID $CHANNEL_NAME -asOrg PublicOrg
    res=$?
    set +x
    if [ $res -ne 0 ]; then
        echo "Failed to generate anchor peer update for QmeOrg..."
        exit 1
    fi
    echo
}

function generateCerts() {
    which cryptogen
    if [ "$?" -ne 0 ]; then
        echo "cryptogen tool not found. exiting"
        exit 1
    fi
    echo
    echo "##########################################################"
    echo "##### Generate certificates using cryptogen tool #########"
    echo "##########################################################"

    if [ -d "crypto-config" ]; then
        rm -Rf crypto-config
    fi
    set -x
    cryptogen generate --config=./crypto-config.yaml
    res=$?
    set +x
    if [ $res -ne 0 ]; then
        echo "Failed to generate certificates..."
        exit 1
    fi
    echo
}

function copyAdmin() {
    orgName=public
    cp crypto-config/peerOrganizations/${orgName}.peer.com/users/Admin@${orgName}.peer.com/msp/signcerts/Admin@${orgName}.peer.com-cert.pem crypto-config/peerOrganizations/${orgName}.peer.com/peers/peer0.${orgName}.peer.com/msp/admincerts/

    orgName=government
    cp crypto-config/peerOrganizations/${orgName}.peer.com/users/Admin@${orgName}.peer.com/msp/signcerts/Admin@${orgName}.peer.com-cert.pem crypto-config/peerOrganizations/${orgName}.peer.com/peers/peer0.${orgName}.peer.com/msp/admincerts/
}

if [ "$1" == "init" ]; then
    if [ ! -d "crypto-config" ]; then
        generateCerts
        copyAdmin
    fi

    if [ ! -d "channel-artifacts" ]; then
        generateChannelArtifacts
    fi

    ./ccp-generate.sh
    ./env-generate.sh
elif [ "$1" == "uninit" ]; then
    rm -rf crypto-config
    rm -rf channel-artifacts
    rm -rf orderer.order.com
    rm -rf peer0.*.peer.com
elif [ "$1" == "copy" ]; then
    copyAdmin
fi