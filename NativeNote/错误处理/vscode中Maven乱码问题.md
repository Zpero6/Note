### 问题：

maven 配置 pom jdk版本为17 ， setting。json 设置 maven  terminal jdk版本为 jdk 21

compile 只在1.8 和17之间可以通过 ， 和21就会报错  NoSuchFile 

### 报错：

maven jdk版本不兼容 。 21 和 17 ，8 之间不兼容 。

### 解决：

将 maven terminal 版本下降到17





### 问题：

程序打印 日志包含中文会乱码， 控制台编码为 UTF-8 ， pom定义jdk版本为17 ， maven terminal ， 环境变量 ， default terminal均为jdk17 ， 但是打印中文会失败。



### 解决：

往maven pom 文件中加入<buile> <pulgin> 配置plugin为 utf-8 编码

或者 在 terminal default 的启动参数上加入  JAVA_TOOL_OPTIONAL= -Dfile.encoding=UTF-8



### 问题：

在maven pom定义 jdk 版本为1.8 ， default terminal，maven terminnal jdk版本都是1.8 。 但是compile 会乱码 ， 打印中文和显示中文路径会乱码 。 控制台编码为UTF-8

### 解决：

在 terminal default 的启动参数上加入  JAVA_TOOL_OPTIONAL= -Dfile.encoding=UTF-8 ， 把java confugire classpath 编译和运行jdk版本修正 。 



### 问题：

在把控制台编码修正为 GBK后， （chcp 936）， 重新打开java项目  maven compile 中文路径没乱码 ， 运行中文打印没乱码 。 

此时 java confugire classpath jdk 版本为 1.8 ，maven 1.8 ， maven terminal 1.8 ， 甚至我把  JAVA_TOOL_OPTIONAL= -Dfile.encoding=UTF-8  选项注释后竟然可以打印中文 和  maven complie 带中文路径的maven项目 。



# 解决方案：

java configuration claspath ， maven terminal ， 集成终端 jdk 全部一致 。 

pom 文件中UTF-8 。

 加入参数JAVA_TOOL_OPTIONAL= -Dfile.encoding=UTF-8  

系统变量 设置JAVA_TOOL_OPTIONAL= -Dfile.encoding=UTF-8  

setting.xml放入UTF-8
