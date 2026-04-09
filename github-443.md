Failed to connect to [github.com](https://link.zhihu.com/?target=http%3A//github.com) port 443 : Timed out

## 一、问题描述

如下图所示，无法 git clone 来自 [Git](https://zhida.zhihu.com/search?content_id=229558034&content_type=Article&match_order=1&q=Git&zhida_source=entity)hub 上的仓库，报端口 443 错误

![](https://pic1.zhimg.com/v2-3b264466dfeec3e70ff0534c35da18c2_1440w.jpg)

## 二、问题分析

Git 所设端口与系统代理不一致，需重新设置

## 三、解决方法

### 3-1、打开[代理页面](https://zhida.zhihu.com/search?content_id=229558034&content_type=Article&match_order=1&q=%E4%BB%A3%E7%90%86%E9%A1%B5%E9%9D%A2&zhida_source=entity)

打开 设置 --> [网络与Internet](https://zhida.zhihu.com/search?content_id=229558034&content_type=Article&match_order=1&q=%E7%BD%91%E7%BB%9C%E4%B8%8EInternet&zhida_source=entity) --> 查找代理

![动图封面](https://pic2.zhimg.com/v2-baceb7a931e8f13ff5b0956a68955639_b.jpg)

记录下当前系统代理的 IP 地址和端口号

如上图所示，地址与端口号为：127.0.0.1:7890

### 3-2、修改 Git 的网络设置

```bash
# 注意修改成自己的IP和端口号
git config --global http.proxy http://127.0.0.1:7890 
git config --global https.proxy http://127.0.0.1:7890
```

![](https://pic2.zhimg.com/v2-32f6f2e6e7ea50f9de6f9aa35bd56dcd_1440w.jpg)

## 四、完结撒花

可以重新 clone 尝试了（其实主要解决的是为啥搭建了梯子依旧不好使的问题，哈哈哈）

## 五、后记

当我们访问GitHub的时候一般都会使用梯子，所以往上推代码的时候也是需要梯子，没有梯子推送成功概率很低，一般都会报错超时，所以设置梯子提高访问成功率；

取消代理是因为，访问 [Gitee](https://zhida.zhihu.com/search?content_id=229558034&content_type=Article&match_order=1&q=Gitee&zhida_source=entity) 或其它是不需要梯子，所以要取消代理；或者后悔设置代理了，也可以利用此取消

```bash
# 取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy

# 查看代理
git config --global --get http.proxy
git config --global --get https.proxy
```
