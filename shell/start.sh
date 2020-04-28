###
 # @Date: 2020-04-28 09:32:59
 # @Author: Ewkoll
 # @Description: 构建非容器模型运行的简单Fabric网络。
 # @FilePath: /fabric/shell/start.sh
 # @LastEditTime: 2020-04-28 11:06:55
 ###
#!/bin/bash

cd ../
INIT_PATH=$(pwd)
WORK_PATH=$(pwd)
ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')")
MARCH=$(uname -m)

###
 # * 调整工作目录。
###
adjuestWorkPath() {
    cd $1
    WORK_PATH=$(pwd)
}

###
 # * 恢复工作目录。
###
restoreWorkPath() {
    cd ${INIT_PATH}
}

###
 # * 下载列子代码。
###
downloadFabricSample() {
    scripts/bootstrap.sh -d -b
}

###
 # * 启动Order节点。
###
startOrder() {
   set -x
   set +x
}

###
 # * 启动Fabcar网络环境。
###
startFirstNetwork() {
    adjuestWorkPath fabric-samples/first-network
    echo $(pwd)
    echo y | ./byfn.sh down
    # echo y | ./byfn.sh up -c mychannel
    restoreWorkPath
}

###
 # * 启动Fabcar网络环境。
###
setPath() {
    export PATH=${PWD}/build/bin:${PWD}/shell:$PATH
}

printHelp() {
    echo "Usage: start.sh command [options]"
    echo
    echo "options:"
    echo "-h : this help"
    echo
    echo "e.g. start.sh download"
    echo "would download fabric sample."
}

setPath
echo "##########################################################"
echo "############# Parse command and start shell ##############"
echo "##########################################################"
SubCommand=$1
shift
while getopts "h?" opt; do
    case "$opt" in
    h | \?)
        printHelp
        exit 0
        ;;
    esac
done

if [ "${SubCommand}" == "download" ]; then
    downloadFabricSample
elif [ "${SubCommand}" == "orderer" ]; then
    startOrder
elif [ "${SubCommand}" == "first-network" ]; then
    startFirstNetwork
else
    printHelp
    exit 1
fi
