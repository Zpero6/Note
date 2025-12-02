## 1. 为什么要替换session

在tomcat服务器中 , session是每个tomcat服务器单独创建和维护的 , 无法做到负载均衡的tomcat服务器集群

中共享session , 因而无法做到服务器的负载均衡 , 仍旧由每个tomcat单独维护 . 

为了解决用户的信息在各个服务器之间共享的问题 , 需要用一个所有服务器都可以访问的东西 , 就是Redis集群

## 2. 对哪些业务进行了修改?

**<1>对service代码逻辑进行修改 :**

​	在发送验证码后 , 将信息存在session这一步 , 要把 code存在Redis中 . stringRedisTemplete将所有序列化为string类型

​	在登录阶段  ,  从Redis中获取code和form表单提交的信息对比 , 然后查询手机号对应的用户 , 保存为UseDTO(去掉隐私信息) . 后生成token作为键存入Redis(需要把long类型的id转换为string类型) . 最后返回给前端一个token

​	登录状态要进行限时 

**<2>对拦截器进行修改**

​	拦截器要从请求头中获取token , 用token查询用户 , 把查询到的用户信息从Redis中取出 , 放入threadlocal.