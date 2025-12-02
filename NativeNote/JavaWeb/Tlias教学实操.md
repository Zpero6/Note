## 删除部门



## **员工分页查询**

 **首先先明确 三层之间的数据传递**

前端想要的 结果是 封装起来的 pageBean  , 包含总数据条目 , 每一页显示的信息 , 每次都要向后端发送分页数据请求

controller 层要做的 就是 开启数据的查询和返回 最后的结果 pageBean  起到前后端交互的作用

要想把 数据展示出来 , 还要把 总数据数展示 , mapper 层一定是把 select 出来的数据项 封装到list 传递 servie 层

sevice 负责把 传出来的数据 展示出来 , 然后把 总数居条目 和 分页的员工信息 封装到 pageBean中 , 传递给 pageBean , 属于信息加工的作用

**然后向传递的参数**

- mapper 层做的是 得到分页的员工信息 , 然后返回list , 根据语法  需要limit 限制读取的范围
  - limit start ,size
- service 层做的是 给mapper 层 参数start 和 size , 然后组装结果到pageBean中 
  - total , list<Emp>
  - start = ( 页面数-1 )  *  pageSize
- controller层负责向 service 传递  页面数 和 papeSize

### 使用插件

```java
/**
     * 分页查询 ,把读到的分页信息 封装到pageBean中
     * @param page
     * @param pageSize
     * @return
     */
    @Override
    public pageBean page(Integer page, Integer pageSize) {
        //1. 获取总记录数
        Long total = empMapper.count();
        // 2. 获取分页的结果列表
        Integer start = (page - 1) * pageSize;
        List<Emp> empList = empMapper.page(start,pageSize);
        //3. 封装到pageBean
        pageBean pageBean = new pageBean(total,empList);
        return pageBean;
    }

```

手动分页 , 就是查询的limit 条件需要自己手动设置 , 然后 mapper 查询 出带limit的结果 ,然后手动封装PageBean

```java
@Override
public PageBean page(Integer page, Integer pageSize) {
    //1. 获取总记录数
    PageHelper.startPage(page,pageSize);
    // 2. 获取分页的结果列表
    List<Emp> empList = empMapper.list();
    Page<Emp> p = (Page<Emp>) empList;

    //3. 封装到pageBean
    PageBean pageBean = new PageBean(p.getTotal(), p.getResult());
    return pageBean;
}

//mapper
    /**
     * 分页查询  列出记录
     * @param start
     * @param pageSize
     * @return
     */
   @Select("select * from tlias.emp limit #{start},#{pageSize}")
  public List<Emp> page(Integer start , Integer pageSize);
```

插件自动的把所有数据 自动执行带limit的语句(mapper的sql语句后自动加的limit 条件) , 然后 select count(0) , 找到total , 

使用pagehelper 封装起来的用强转 转成 page<T> 类型的 , 然后 传入参数自动封装PageBean

### 员工的模糊查询

**如何解决员工的模糊查询?**

首先解模糊查询的sql语句 , 

```sql
select * from emp where name like concat('%',#{name},'%') and gender = #{gender} and entrydate between #{begin} and #{end}
```

  但是我们需要的是某些条件没有的条件下也要做到可以搜索 , 因此需要动态SQL

动态SQL的 要素:

- 同名包 和文件
- `<if>` 等标签

于是乎 我们就要往这个条件里放 一些参与查询的参数 , name, gender entrydate的时间范围 等等

我们就要修改mapper层的参数 , 然后修改 传入 service层的参数 , 然后就是 controller 层传入的参数

因为controller 层接收的是前端传来的参数 , 比如像这个url  :

`http://localhost:90/api/emps?name=张&gender=&begin=&end=&page=1&pageSize=5`

然后就要把那些参数根据 @RequestParam () 设置默认值 , 然后接收前端传来的参数 , 有name, gender等等

####								 Controller代码,传递参数和返回pageBean对象

```java
@GetMapping("/emps")
public Result page(@RequestParam(defaultValue = "1") Integer page,
                   @RequestParam(defaultValue = "10") Integer pageSize,
                    String name, Short gender,
                   @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate begin ,@DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate end) {
    log.info("分页查询:{},{}", page, pageSize);
    //调用Service 分页查询
    PageBean pageBean = empService.page(page, pageSize,name,gender,begin , end);
    return Result.success(pageBean);
}
```

然后Mapper层要动态SQL

#### Mapper层代码,查询

```xml
<select id="list" resultType="com.zpero.pojo.Emp">
    select *
    from emp
    <where>
        <if test="name !=null and name != ''">name like concat('%',#{name},'%')</if>
        <if test="gender !=null and gender!=''">and gender = #{gender}</if>
        <if test="begin !=null and end != null">and entrydate between #{begin} and #{end}</if>
    </where>
    order by update_time desc
</select>
```

```java
public List<Emp> list(String name, Short gender, LocalDate begin , LocalDate end);
```

然后Service作为接收 controller 层传入的参数 , 往mapper层传递的中间层 , 改变传入的参数

#### Service代码,传递参数,封装pageBean

```java
@Override
public PageBean page(Integer page, Integer pageSize,String name, Short gender, LocalDate begin , LocalDate end) {
    //1. 获取总记录数
    PageHelper.startPage(page,pageSize);
    // 2. 获取分页的结果列表
    List<Emp> empList = empMapper.list(name,  gender,  begin ,  end);
    Page<Emp> p = (Page<Emp>) empList;

    //3. 封装到pageBean
    PageBean pageBean = new PageBean(p.getTotal(), p.getResult());
    return pageBean;
}
```

模糊查询就是在分页查询的基础上 加了 动态的查询条件 ,  然后插件根据查询出来的结果 再 执行select Count(0) 找到total  , 然后拼接 limit 子句 , 找到所在分页 的查询结果 , 然后 封装到 pageBean对象 传递给 controller 





### 配置参数化

yml文件中

```yml
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/tlias
    username: root
    password: 123456
  servlet:
    multipart:
      max-file-size: 10MB
      max-request-size: 100MB

mybatis:
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
    map-underscore-to-camel-case: true

server:
  port: 8080
  address: 127.0.0.1
```

简单不繁琐

#### @configurationProperties

![image-20250731153616959](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507311536254.png)

指定 prefix 前缀是必须的



### 登录校验

在未登录的情况下 , 可以访问系统的功能



![image-20250731201224542](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507312012765.png)

> 登录标记 
>
> 每一次登录都可以访问到登录标记 , 确定登录的状态

登录标记属于会话技术



> 统一拦截
>
> 避免 每一个controller去重复判断 登录状态
>
> 所以需要统一拦截 , 校验放行

 过滤器 Filter

拦截器interceptor

#### 会话技术

会话就是 用户的浏览器 访问web服务器 后通信的过程 

访问服务器建立 会话 , 断开连接 会话关闭 

一次会话有多次的请求相应



为了保持浏览器的浏览状态 , 需要跟踪请求的来源是否来自统一浏览器

方便在同一次会话中共享数据

技术方案:

- C端跟踪技术: cookie
- S端跟踪技术: Session
- 令牌

##### cookie

在浏览器第一次访问系统 资源  ,  服务器端会记录当前浏览器的用户名,用户id等信息 , 

返回给浏览器 , 存储在浏览器本地

后续的请求中都会自动携带cookie到S端 , 判断cookie的值是否存在

> 优点:
>
> HTTP支持Cookie 的请求头 	 

> 缺点:
>
> 移动端无法使用
>
> 不安全,用户可以自己禁用cookie
>
> cookie不可以跨域
>
> > 跨域是指浏览器和服务器通信 , 前后端不是部署在同一台电脑的情况下 ,  IP地址和端口号都不一样的现象
> >
> > 跨域的三个温度: 协议 , ip/域名 , 端口号

##### session

c端第一次访问服务器时 , s端会生成一个Session

服务器生成一个唯一的SessionId JSESSIONID

后续请求只需带上这个ID  , 服务器就可以识别出这个用户  的会话

> HttpOnly参数
>
> 重要的web安全配置 , 防止javascript访问cookie ,防御 跨站脚本攻击
>
> 设置后不能被js读取或修改
>
> 只能在浏览器发起http请求携带

浏览器请求携带 Session Id 和 服务器传递 Session Id 是依靠 Http 的Cookie 字段传递的

> 好处:
>
> 存在服务器端 , 安全

> 坏处:
>
> 服务器集群情况下无法使用Session
>
> cookie的缺点都有

##### 令牌技术

一个经过签名的字符串，用来代表某个用户的身份。

用户登录成功后，系统生成一个 Token 返回给客户端。

客户端在后续请求中附带这个 Token。

服务器验证 Token 是否有效，来决定是否放行请求。

> 支持 pc移动端
>
> 解决集群环境下的认证问题
>
> 减轻s端存储压力

###### JWT令牌

json web token

组成:header  payload有效载荷 signature签名

header: 记录令牌类型 ,签名算法

payload:携带自定义信息,默认信息

signature:防止token被篡改 , 确保安全  . 把header和payload 加入指定密钥(服务器保存的) , 通过 header的签名算法计算而来

签名中有前两部分的信息 , 如果篡改了 , 就会失效

经过base64编码后的来的token



使用JSON格式 传输  Map<String , object> 

jwts.builder(){

​	signwith(SingnatureAlgorithm:method , "screct key" )   签名的方式 , 密钥 (header)

​	setClaims(Map<>) 							   (payload)

​	setExpiration(new Date(system.currentTimeMillis() + ****) )    有效日期

​	compact()									连结

}

解码

jwts.parser(){

​	setSigningKey("serect key")      设置解码密钥

​	parseClaimsJws(jwt) 		 解码

​	getBody()				    转换json格式

}



##### 响应信息

存储在浏览器本地存储中 





#### 过滤器

##### Filter

是web三大组件之一 (Servelet , Filter,Linsener)

过滤器可以请求拦截下来 ,实现登录验证功能 , 统一编码处理 , 敏感词字符处理

###### 配置

@WebFilter 配置拦截资源路径

@ServletComponentScan 开启Servlet组件支持



##### 过滤器链

一个web应用中 ,可以配置多个过滤器, , 形成一个过滤器链

注解配置Filter,优先级按照字符串的自然排序(类名)

##### 设置登录检查放行

首先如果是登录操作 , 直接放行  

如果是其他操作

- 检查是否有jwt , 从请求头中拿到token 
- 检验token字段是否为空 , 如果空, 让他滚蛋报错 NOT_LOGIN Result错误结果
- 如果不是空 , 检验是否valid , 如果失效 , 滚蛋报错 NOt_LOGIN Result错误结果
- 如果合法 , 放行

#### 拦截器

一种动态拦截方法调用的机制 ,类似过滤器 , spring框架提供,用来动态拦截控制器方法的执行

拦截请求 , 在指定的方法调用前后 , 根据业务需要执行预先设定的代码



### 登录校验顺序

过滤器--------> (请求拦截)---------> DispacherServlet------------> Interceptor----------->controller

​												| -----------------spring-------------------|

### 异常处理

