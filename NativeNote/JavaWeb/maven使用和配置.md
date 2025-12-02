## 什么是maven

maven是java项目的构建工具 , 它的核心作用是 

- 自动管理项目依赖 , 避免版本冲突问题

- 统一编译打包流程 , 标准跨平台的自动化项目构建(linux , windows , macos)
- 组织项目结构 , 生成出的maven工程目录是固定的

![image-20250716215718934](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507162157012.png)

### maven仓库

用于存储资源,管理各种jar包

- 本地仓库,在自己计算机上
- 中央仓库, 由maven团队维护
- 远程仓库,搭建的私有仓库

如果本地仓库有jar包,优先关联本地仓库 . 如果本地没有,则会连接中央仓库

## maven安装

https://maven.apache.org/download.cgi

解压

## maven配置

打开环境变量,创建MAVEN_HOME ,路径设置为解压后的路径

<img src="https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507171438169.png" alt="image-20250717143558061" style="zoom:33%;" />

在path中添加 `%MAVEN_HOME%\bin`

<img src="https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507171438806.png" alt="image-20250717143851766" style="zoom:33%;" />

然后 在命令行中测试 : `MVN -V` 出现如下即可

![image-20250717143959606](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507171439647.png)

如果没有的,打开maven的bin目录,点击 mvn.cmd,开始运行初始化

![image-20250717144056756](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507171440798.png)

### 创建maven项目

<img src="https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507162304116.png" alt="image-20250716230409034" style="zoom: 33%;" />

关闭项目-->打开所有设置-->

<img src="https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507162305337.png" alt="image-20250716230501296" style="zoom:33%;" />

设置如上,把主路径设置为maven安装的地方

<img src="https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507162306300.png" alt="image-20250716230617246" style="zoom:33%;" />

把JRE设置为自己的JDK版本

创建新项目,选择maven,更换组Id 

<img src="https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507162308247.png" alt="image-20250716230816208" style="zoom:33%;" />

完成

### maven坐标

> 坐标是 资源的唯一标识符 , 通过该坐标可以唯一等位资源位置,使用坐标来定义项目或引入项目中需要的依赖

> 坐标构成:
>
> - groupId:定义当前maven项目隶属的组织名
> - artifactId: 定义当前maven项目名称
> - version:定义当前项目版本号

想要添加jat包,只需要在pom.xml中 添加如下代码

```xml
<dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
```

需要什么依赖 artifatId中间添加什么