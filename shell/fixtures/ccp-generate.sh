#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp() {
    local PA=$(one_line_pem $5)
    local PB=$(one_line_pem $6)
    local PC=$(one_line_pem $7)
    local PD=$(one_line_pem $8)
    local PE=$(one_line_pem $9)
    sed -e "s/\${ORG}/${1}/" \
        -e "s/\${L_ORG}/${2}/" \
        -e "s/\${P0PORT}/${3}/" \
        -e "s/\${CAPORT}/${4}/" \
        -e "s#\${ADMIN_PRIKEY_PATH}#${5}#" \
        -e "s#\${ADMIN_PRIKEY}#$PA#" \
        -e "s#\${ADMIN_CERT_PATH}#${6}#" \
        -e "s#\${ADMIN_CERT}#$PB#" \
        -e "s#\${ORDERER_PEM}#$PC#" \
        -e "s#\${PEERPEM}#$PD#" \
        -e "s#\${CAPEM}#$PE#" \
        ccp-gateway.json
}

basepath=$(cd `dirname $0`; pwd)

ORG=Government
L_ORG=government
P0PORT=7051
CAPORT=7054
ADMIN_PRIKEY_FILE=$(cd crypto-config/peerOrganizations/$L_ORG.peer.com/users/Admin@$L_ORG.peer.com/msp/keystore/ && ls *_sk)
ADMIN_PRIKEY=$basepath/crypto-config/peerOrganizations/$L_ORG.peer.com/users/Admin@$L_ORG.peer.com/msp/keystore/${ADMIN_PRIKEY_FILE}
ADMIN_CERT=$basepath/crypto-config/peerOrganizations/$L_ORG.peer.com/users/Admin@$L_ORG.peer.com/msp/signcerts/Admin@$L_ORG.peer.com-cert.pem
ORDERER_PEM=crypto-config/ordererOrganizations/order.com/tlsca/tlsca.order.com-cert.pem
PEERPEM=crypto-config/peerOrganizations/$L_ORG.peer.com/tlsca/tlsca.$L_ORG.peer.com-cert.pem
CAPEM=crypto-config/peerOrganizations/$L_ORG.peer.com/ca/ca.$L_ORG.peer.com-cert.pem

echo "$(json_ccp $ORG $L_ORG $P0PORT $CAPORT $ADMIN_PRIKEY $ADMIN_CERT $ORDERER_PEM $PEERPEM $CAPEM)" > connection-${L_ORG}.json

ORG=Public
L_ORG=public
P0PORT=8051
CAPORT=8054
ADMIN_PRIKEY_FILE=$(cd crypto-config/peerOrganizations/$L_ORG.peer.com/users/Admin@$L_ORG.peer.com/msp/keystore/ && ls *_sk)
ADMIN_PRIKEY=$basepath/crypto-config/peerOrganizations/$L_ORG.peer.com/users/Admin@$L_ORG.peer.com/msp/keystore/${ADMIN_PRIKEY_FILE}
ADMIN_CERT=$basepath/crypto-config/peerOrganizations/$L_ORG.peer.com/users/Admin@$L_ORG.peer.com/msp/signcerts/Admin@$L_ORG.peer.com-cert.pem
ORDERER_PEM=crypto-config/ordererOrganizations/order.com/tlsca/tlsca.order.com-cert.pem
PEERPEM=crypto-config/peerOrganizations/$L_ORG.peer.com/tlsca/tlsca.$L_ORG.peer.com-cert.pem
CAPEM=crypto-config/peerOrganizations/$L_ORG.peer.com/ca/ca.$L_ORG.peer.com-cert.pem

echo "$(json_ccp $ORG $L_ORG $P0PORT $CAPORT $ADMIN_PRIKEY $ADMIN_CERT $ORDERER_PEM $PEERPEM $CAPEM)" > connection-${L_ORG}.json