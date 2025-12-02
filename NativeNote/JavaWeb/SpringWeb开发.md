## 创建SpringBoot项目工程

idea中新建项目,选择springboot,类型选择 maven , 依赖项选择web/spring web

项目目录结构和maven的差别:

![image-20250717144453800](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507251111462.png)

resources文件中多了 applecation.properties  Spring boot配置文件

### 测试

在 `com.zpero`文件中创建 `controller`软件包,添加HelloTest文件

```java
@RestController
public class HelloController {
    @RequestMapping("/hello")
    public String Hello(){
        System.out.println("hello world");
        return "hello world";
    }
}
```

由于创建的web app , 在浏览器中 打开 `localhost:8080/hello`

如果8080打不开,那么看看是不是没有把启动文件放在父级包下: 

![202507171456075](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507251214625.png)

**如图,启动文件应该在controller的父级包下,而不是同级包或子包**

端口号看tomcat容器给的端口

![202507171457717](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507251214117.png)

> **@RestController**
>
> spring boot  用于创建RESTful Web服务, <mark>标记当前类是一个控制器</mark>  , 并且所有方法返回的对象会<mark>自动化序列为JSON 或 xML , 直接作为 HTTP响应体返回</mark>
>
> **@RequestMapping** 
>
> Spring框架最基础最常用的注解之一 , 将HTTP请求映射到某个控制器后方法上 , <mark>定义了前端请求的"入口地址"</mark>
>
> **@RequestParam注解**
>
> - 方法形参名称与请求参数名称不匹配,通过注解完成映射
> - 该注解的required属性默认是true,代表请求参数必须传递

### ![202507171452321](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507251214037.png)速通`

[见此](https://juejin.cn/spost/7527618514572935194)



## 请求响应

### 前端请求传参

```java
//HttpServletRequest  原始方法
@RequestMapping("/simpleParam")
    public String simpleParam(HttpServletRequest request) {
        String name = request.getParameter("name");
        String ageStr = request.getParameter("age");
        int age = Integer.parseInt(ageStr);
        System.out.println(name + " " + age);
        return "ok" ;
    }
// @RequestParam 注解映射
    @RequestMapping("/simpleParam1")
    public String simpleParam(@RequestParam(name = "name" , required = false) String usrname , Integer age){
        System.out.println(usrname + " " + age);
        return "get";

    }
```

> 使用HttpServletRequest
>
> - 使用原始 Servlet API获取参数
>
> - 需要手动处理参数的转换
>
> - age 参数如果缺失会抛出 NumberFormatException错误 
>
>   ​	` java.lang.NumberFormatException: Cannot parse null string] with root cause`
>
> 使用Spring注解
>
> - `@RequestParam(name = "name" , required = false) `指定前端参数名必须为 "name" , 把name绑定到 username
> - required 参数决定参数是否必须 , 如果为true 时没有传入 name , 则会抛出错误 `MissingServletRequestParameterException ` 
>
> - Spring 会自动进行类型转换 , 将 String (text) 类型的传入参数 age 转换为 Integer
>
> 

#### 传递嵌套实体参数

```java
 @RequestMapping("/getUserPojo")
    public String simplePojo(@ModelAttribute User user){
        System.out.println(user);
        return "get user "+ user.toString();
    }
//pojo文件夹中
public class Account {
    private String id;
    private  String price;
}
//添加getter setter tostring
public class User {
    private String name;
    private  int age;
	private Account ac;
}
```

postman信息:

![202507172312159](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507251215121.png)

![202507172312328](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507251215092.png)

`类名.属性` 给嵌套pojo属性传递参数

**请求参数名和形参对象的属性名相同,按照对象层次结构关系既可以接收嵌套Pojo属性参数**

> @ModelAttribute 注解
>
> 将请求中的参数自动封装到一个 pojo 对象中 , 并将该对象添加到Spring  的Model中
>
> 可以不写 , 但是方便后期视图

#### 传入数组

```java
@RequestMapping("/arrayParam")
public String arrayParam(String[] form){
    System.out.println(Arrays.toString(form));
    return "form data received " ;
}

@RequestMapping("listParam")
public String listParam(@RequestParam List<String> form){
    System.out.println(form);
    return "received list of form";
}
```

把发送的参数传入 form 数组中 

#### 传入日期

```java
@RequestMapping("dateParam")
public String dateParam(@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")LocalDateTime date){
    System.out.println(date);
    return "date = " + date;
}
```

![202507181457378](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507251217727.png)



#### 传入Json参数

```java
@RequestMapping("jsonParam")
public String JsonParam(@RequestBody User user){
    System.out.println(user);
    return "Josn" + user ;
}
```

```json
{
    "name" : "张三",
    "age"  : 22,
    "ac" : {
        "id" : "漆黑烈焰使" ,
        "price" : 8888
    }
}   
```

> json数据键名应该与形参对象的属性名相同, 需要@RequestBody标识 , <mark>SpringMVC 知道从HTTP请求中读取Json数据 , 将其反序列化为Dept对象   </mark> ,   不然无法传入数据



#### 路径参数

```java
  @RequestMapping("/simpleParam2/{id}")
    public String simpleParam(@PathVariable String id){
        return "userid" + id;
    }

```

### 响应请求

#### 统一响应结果

```java
//创建pojo/Result.java
public class Result {
    private  Integer code;
    private String msg;
    private  Object data;
}
//添加getter setter 构造器
```

```java
//创建ResponseController.java
@RestController
public class ResponseController {
    @RequestMapping("/RespUserPojo")
    public Result simplePojo(@ModelAttribute User user){
        System.out.println(user);
        return new Result(1,"success",user);
    }

}
```

```html
localhost:8080/RespUserPojo?name=dfdfdfdfdfsssd&age=22&ac.id=dfdfdfdfdfdfdf&ac.price=1222
```

### 案例

```
//添加文件
resources
        ├── static
        │   ├── element-ui
        │   ├── js
        │   └── emp.html
        ├── templates
        ├── application.properties
        └── emp.xml
        
com
└── zpero
    ├── controller
    │   ├── EmpController
    │   ├── HelloController
    │   ├── RequestController
    │   └── ResponseController
    ├── dao
    │   ├── EmpDao
    │   └── impl
    │       └── EmpDaoImpl
    ├── pojo
    │   ├── Account
    │   ├── Emp
    │   ├── Result
    │   └── User
    ├── service
    │   ├── EmpService
    │   └── impl
    │       └── EmpServiceImpl
    └── Utils
        └── XmlParserUtils

```

链接: [JavaWeb](https://pan.baidu.com/s/1OD0TzAGI-DK1TgIw8X-yiQ?pwd=4ati) 提取码: 4ati

添加接口和实现类

```java
public class EmpDaoImpl implements EmpDao {
    @Override
    @RequestMapping("/listEmp")
    public List<Emp> list() {
        String file = this.getClass().getClassLoader().getResource("emp.xml").getFile();
        System.out.println(file);
        List<Emp> empsList = XmlParserUtils.parse(file, Emp.class);
        return empsList;
    }
}
```

```java
public class EmpServiceImpl implements EmpService {
    private EmpDao dao = new EmpDaoImpl();
    @Override
    public List<Emp> listEmp() {
        List<Emp> empsList = dao.list();
        empsList.stream().forEach(
                emp -> {
                    String gender = emp.getGender();
                    if("1".equals(gender)){
                        emp.setGender("男");
                    }else if("2".equals(gender)){
                        emp.setGender("女");
                    }

                    String job = emp.getJob();
                    if("1".equals(job)){
                        emp.setJob("讲师");
                    }else if("2".equals(job)){
                        emp.setJob("班主任");
                    }
                    else if("3".equals(job)){
                        emp.setJob("就业指导");
                    }
                });
        return empsList;
    }
}
```

```java
@RestController
public class EmpController {
    private EmpService empService = new EmpServiceImpl();
    @RequestMapping("/listEmp")
    public Result list(){
        List<Emp> empsList = empService.listEmp();
        return Result.success(empsList);
    }
}
```



####  分层解耦设计方式

##### 分层

> **三层架构**
>
> - Controller : 控制层, 接收前端发送的请求,对请求进行处理 ,并且响应数据
>
> - Service : 业务逻辑层 , 处理具体的业务逻辑
>
> - Dao : 数据访问层 , 负责数据访问操作 , 包括数据的增删改查
>
> 案例中,EmpDao封装了获取文件的数据访问逻辑, EmpService封装了对获取到的数据的处理逻辑, EmpController封装了EmpService 并将处理后的数据 统一化 成Result , 是起点也是终点

##### 解耦

> **什么是耦合?**
>
> 耦合指的是系统的模块之间的依赖关系
>
> 以上述案例为例, Controller层 保存了Service 层的对象 , 并且new了一个实现方式EmpServiceImpl , 如果把这个new出来的对象换成另一个,那么Controller层的代码需要改动,也就是说Controller 和 Service还有 耦合



> **控制反转(IOC)**
>
> 对象的创建控制权由程序自身转移到外部容器
>
> **依赖注入**
>
> Spring 会自动查找容器中**类型匹配的 Bean**并注入
>
> **Bean对象**
>
> IOC容器中创建,管理的对象成为Bean

![202507191607783](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507251217019.png)

![202507191607254](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507251217167.png)

![202507191608795](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507251218960.png)

> **@Component**
>
> 将当前类交给IOC容器管理,并成为IOC的Bean
>
> *衍生注解*
>
> - @Controller
> - @Service
> - @Repository(Dao层)
>
> *用法*
>
> - @注解("Bean名字") , 默认是类名首字母小写
> - 除了控制器必须要用@Controller ,其他的既可以用同层次的注解,也可以用@Component
>
> **@Autowired**
>
> IOC 自动将匹配的bean注入到当前类中需要的地方
>
> - ***默认按类型匹配（byType）：***如果有多个相同类型的 Bean，可能会报错。
>   - 可以使用@Primary 注解到需要的类
> - ***可以搭配 `@Qualifier` 指定注入的 Bean 名称*** 
>   - `@Qualifier("EmpDaoImpl")`
> - ***可选注入***:
>   - 使用 `required = false` ,表示没有也不报错
>
> 

![image-20250719165621278](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507191656550.png)

#### bean组件扫描

> Spring 启动时会扫描带有 `@Component`, `@Service`, `@Repository` 等注解的类，并将它们注册为 Bean。
>
> 默认扫描范围是启动类所在的包及其子包
>
> 案例而言, 启动类SpringWebQucikstartApplication 在com.zpero中,扫描范围就是com.zpero所有的文件
>
> 但是当文件被移动后(从zpero中移入了com),脱离了扫描范围,再像要被管理就要 重新定义扫描范围
>
> ```java
> @ComponentScan({
>         "com.dao" , "com.zpero"
> })
> ```
