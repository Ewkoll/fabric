###
 # @Date: 2020-04-28 09:32:59
 # @Author: Ewkoll
 # @Description: 构建非容器模型运行的简单Fabric网络。
 # @FilePath: /fabric/shell/start.sh
 # @LastEditTime: 2020-04-29 09:51:10
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
startFabcar() {
    adjuestWorkPath fabric-samples/fabcar
    echo $(pwd)
    echo y | ./startFabric.sh
    restoreWorkPath
}

###
 # * 停止Fabcar网络环境。
###
stopFabcar() {
    adjuestWorkPath fabric-samples/fabcar
    echo $(pwd)
    echo y | ./stopFabric.sh
    restoreWorkPath
}

###
 # * 启动Fabcar网络环境。
###
setPath() {
    export PATH=${PWD}/.build/bin:${PWD}/shell:$PATH
}

###
 # * 生成配置文件。
###
generateConfig() {
    cd ${INIT_PATH}/shell/fixtures
    ./init.sh init
    restoreWorkPath
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
elif [ "${SubCommand}" == "fabcar_start" ]; then
    startFabcar
elif [ "${SubCommand}" == "fabcar_stop" ]; then
    stopFabcar
elif [ "${SubCommand}" == "generate" ]; then
    generateConfig
else
    printHelp
    exit 1
fi
