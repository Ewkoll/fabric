<!--
 * @Date: 2020-04-28 14:50:24
 * @Author: Ewkoll
 * @Email: ideath@operatorworld.com
 * @Description: 常见错误信息。
 * @FilePath: /fabric/shell/doc/readme.md
 * @LastEditTime: 2020-04-28 16:25:03
 -->

# 常见错误

* [failed to copy files: Error processing tar file(bzip2 data invalid: bad magic value in continuation file)](https://jira.hyperledger.org/browse/FAB-15665)

  * mac 系统下安装

    ``` bash
    brew install gnu-tar
    ```

  * 设置环境变量

    ``` bash
    GNUBIN=/usr/local/opt/gnu-tar/libexec/gnubin
    export PATH=$GNUBIN:$PATH
    ```

  * 如果在次运行出现相同的错误

    ``` bash
    make clean
    ```

* .build/docker/gotools/bin/protoc-gen-go: No such file or directory 默认会安装到$(GOPATH)/bin
