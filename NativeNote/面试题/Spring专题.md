
## Spring是什么，有什么特性 

  **spring是 轻量非侵入式的控制反转和 面向切面的框架**

  #### IOC 和 DI (依赖注入)
  Spring的核心是一个工厂容器，维护所有对象的创建和依赖关系
  spring工厂生产Bean ，管理Bean的生命周期，实现高内聚和低耦合的设计概念

  #### AOP 的支持
  Spring提供面向切面编程，不修改源代码实现动态代理，在关键执行点插入额外逻辑

  #### 声明式事务支持
  通过配置完成对事务的管理，不再需要手动编写事务提交和回滚的行为

  #### 快速测试
  提供Junit支持，通过注解快速测试spring程序

  #### 快速集成框架
  内部提供各种框架： Mybatis Struts Hibernate 

  #### 复杂API模板封装
  对JAVAEE 的一些API模板化封装（JDBC,JavaMail 远程调用）

  ### 什么是AOP和IOC？
  Spring提供面向切面编程，不修改源代码实现动态代理，在关键执行点插入额外逻辑

  IOC 将对象的创建和对象之间的调用交给SPring 来管理 


## Spring 源码准备

  ### Spring 循环依赖
  三级缓存

  ### Bean生命周期

  ### AOP

  ### 事务


  ### IOC

## Spring 的模块？

![[Pasted image 20251124200826.png]]



![Spring模块划分](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202511242010122.png)

  #### 主要七模块
  1. spring core :spring 最核心最基础部分，提供IOC 和 DI 特性
  2. spring COntext：上下文容器，是BeanFactory的一个加强子接口
  3. spring Web：提供web开发的支持
  4. springMVC： 针对web应用MVC的实现
  5. spring Dao: 提供对JDBC的抽象层，简化JDBC编码
  6. spring ORM ：支持流行框架的整合
  7. spring AOP： 提供和AOP联盟兼容的编程实现


## spring 使用了那些注解？

  ### Web

  ### 容器

  ### 事务

  ### AOP

## spring用到的设计模式

  1. 工厂模式：
  Beanfactory ：负责创建和管理所有Bean对象，通过注解@Autowired就是通过工厂模式创建和获取对象

  2. 单例模式：
  spring默认行为，默认所有的Bean都是单例的，只有一个实例，节省内存和提高性能

  3. 代理模式：
  AOP基于动态代理，对于实现了接口的类用JDK动态代理，没有实现接口的类用CGLIB代理
  @Transactional 注解标记时创建一个代理对象，在方法执行前后执行事务处理的逻辑
  

  4. 观察者模式： 
  ApplicationEvent和ApplicationListener 时间发布和监听。

  5. 装饰器模式：
  包装类在不改变原有接口的情况下为对象添加额外功能

  6. 适配器模式：
  Dispatcher通过 HandlerAdapter接口和不同类型的Controller 统一请求处理接口

  7. 模板方法模式：、
  RestTemplete JDBCTemplete 等等定义操作的骨架

  ### spring如何实现单例模式？
  传统的单例模式靠在类的内部定义一个实例，private私有构造和getinstance（）获取
  spring的单例时容器级别的，启动的时候把所有的Bean信息都加载，在DefaultSingletonBeanFactory类里面ConcurrentHashMap 存储BeanFactory
  第一次获取Bean ，检查Map里有没有这个Bean，没有创建一个，有直接获取
  

## spring容器和web容器之间的区别？

  spring时一个IOC容器，负责管理java对象的生猛周期和依赖关系

  web容器 运行web程序，处理Http请求和响应数据，管理servlet生命周期

  spring容器处理业务逻辑的对象管理， web容器处理网络通信，接收Http请求，调用servlet 把响应返回客户端

  web容器接收 Http请求，交给DispatcherServlet处理，这个接口又去找相应的Controller 处理

  web容器生命周期和web程序的部署和卸载有关，spring容器 在web应用启动时初始化，web应用关闭时销毁


## 如何理解Bean？
  
   什么样的类可以是Bean？
  java config 配置，注解标注，实现特定接口的类
  **配置方式**
  bean的配置有注解，xml和java配置

  **注解位置**
  在类上使用@component 标注方法时一个组件，注册为Bean
  在方法上使用@Bean 标注方法的返回对象是一个Bean对象，并注册

  @Bean 是java配置，开发者掌握创建过程的控制权

  **生命周期**
  Bean的生命周期分为 5 阶段：
    实例化 属性赋值， 初始化 使用 销毁
  
  1. 实例化 
   spring 容器根据BeanDefinition(创建和配置的元数据) 反射调用Bean的构造方法创建对象实例

  2. 属性赋值
   注入依赖对象，注入配置值（@Value）//@autowired 

  3. 初始化（三明治结构）:
  执行Aware接口 BeanNameAware(自己在容器里的名字), BeanFactoryAware(拿到自己的BeanFactory，取要别的Bean),APplicationCOntextAware（全局资源）
  执行BeanPostProcessor的before方法 
  执行自己的初始化逻辑，@postContrust ，@Bean(initMethod)
  执行BeanPostProcessor的after方法 (AOP动态代理的地方)

  4. 销毁
  spring调用@PreDestory等释放资源

  
## Bean 的作用域有哪些

  Singleton  默认单例bean，@Service等组件默认使用性能高节省内存
  protoType  向容器请求bean都会返回一个新的bean ，适合有状态的对象
  Request    每个Http请求会创建一个Bean，请求结束销毁
  Websocket  每一个连接都创建一个bean
  session 每个用户会话都会创建一个,会话结束销毁
  Application  整个应用只有一个Bean，和ServletContext生命周期绑定
  
  ==Singleton Bean中要注入 protoType bean 只会注入一次== ，因为多例Bean只被创建了一次就会被反复使用
  1. 使用@Lookup注解 ，每次调用获得新的实例
  2. 从ApplicatonContext 动态获取 , 每次获取的都是不同的(作用域为prototype)
   

## 单例bean 会有线程安全问题吗
  
  **spring 容器保证了bean 创建过程的线程安全，但是Bean使用的时候会有线程安全问题**
  
  如果bean 内部有可变成员变量 ，那么就是非线程安全的
  
  **解决办法**：
  JUC 方法：
  1. 使用锁技术 
  2. 使用线程安全类(原子类)
  
  其他方案：
  1. 使用无状态的单例Bean
  2. 对线程相关的状态，使用ThreadLocal 隔离线程之间的操作，每个线程都有自己的副本
  3. Bean需要维护状态，将作用域改成protoType
  

## IDEA 为什么不推荐使用@Autowired 注入bean？

  1. 不利于单元测试 ，字段注入要用反射或者spring 容器才能注入依赖。需要手动设置依赖
     setField(依赖对象，字段名，构造Mock对象)
    
  2. 字段注入有循环依赖问题，在注入的时候才检查。使用构造注入可以直接在项目启动检查，更早发现问题

  3. 给依赖对象加final 修饰可以在对象创建的时候(实例化)就初始化。(构造注入的推荐方法)

  
## Autowired 和 Resource 注解
   
  **Autowired 是byType的，Resource 是byName的**
  当接口有多个实现类的时候，Autowired 不知道寻找哪个实现类
  Resource 可以直接指定实现类的类名注入 ， Autowired 需要加入@Qualifier 指定Bean的名称(byName)

  也就是说，多实现类的情况要用byName的注解

## Auowired 的实现原理
  基于反射和BeanPostProcessor  
 
  **依赖收集**：
  实例化之后，属性赋值之前，Autowired 的processor 扫描Bean的所有字段，方法和构造器，找到标注@Autowired 注解的地方，用反射操作把元数据对象封装成Injection 对象缓存。
 
  **注入**：
  取出缓存的Injection 逐个处理注入点，区IOC容器寻找响应的Bean
  字段注入，用反射Field.set() ；Setter注入用 Mehtod.invoke();

## 什么是自动装配？

   无需告诉Spring Bean之间的依赖关系，Spring容器会找到合适的Bean注入
   **扫描范围**:
   @ComponentScan 标记的范围

   **spring的装配类型**:
  
   byName byType constructor autodetect

   @Autowired 默认按照类型装配
   @Resource 默认按名称装配，名称查询不到用类型装配

   **Spring Boot高级装配机制**;
   @EnableAutoConfiguration 自动配置基础设施Bean。 
   该注解包含在@SpringApplication 注解中
   
   @SpringApplication 注解包含 
   1. @SPringBootConfiguration 标记是配置类
   2. @EnableAutoFonfiguration 启动自动配置的核心注解，扫描Classpath的所有自动配置类
   3. @ComponentScan 扫描组件，发现注册被注解标记的Bean

   

## 循环依赖
  多个Bean相互依赖  a依赖b b依赖a ，或者c依赖c自己

  **spring三级缓存解决依赖循环**：

> 三级缓存机制在bean包内，DefaultSingletonBeanFactory类实现逻辑 ，处理单例Bean的注册获取

  1. 一级缓存 : Map(String,Object) 放初始化号的Bean单例
  2. 二级缓存： Map(String ,Object) 放实例化完成但是没属性填充和初始化的Bean
  3. 三级缓存：存储ObjectFactory，用于生成Bean的代理对象或原始对象 

  **解决流程**:
  调用A的构造方法，A实例化。把A的工厂放入三级缓存
  容器扫描到需要B，寻找Bean找不到创建B实例。B对象已存在，但是依赖的A对象为空(未初始化),B的工厂放入三级缓存
  B一次从一二级缓存寻找A ， 但此时A没有在缓存中，依靠三级缓存中A的工厂找到A，把A 放到二级缓存，把A的引用注入到依赖
  B完成初始化，从三级缓存拿到一级缓存。A从一级缓存中找到B的实例，完成A的初始化

 **例外**：
 1. 使用了构造器注入的Bean，因为实例化的过程中要完成构造，需要拿到依赖的引用，依赖又要拿到实例化后的A。 A无法实例化也就无法从缓存中拿到A。
 2. 多例Bean Spring无法对它进行缓存，也就拿不到实例化后的早期bean(prototype要求每次请求都拿到一个新的Bean，缓存会破坏这个特性)


  
## 为什么要设计三级缓存而不是二级缓存？/三级缓存的必要？
  
  三级缓存是应对代理设计的。
 
  **二级缓存的缺陷**:
  Bean实例化后进入二级缓存，依赖拿到原始对象
  Bean初始化后被原始对象被代理对象覆盖，依赖应该拿到的是代理对象而不是原始对象。（依赖没有更新）
  
  所以应该在依赖拿到Bean的时候就要判断是不是要拿代理对象，再把他放入缓存中。

  **三级缓存的作用**：
  三级缓存的作用是延迟决策，在需要Bean的时候判断是要不要代理对象.

  **二级缓存的作用**:
  解决循环依赖问题
  存放早期引用，如果拿早期引用都要从工厂中拿，可能会创建不同的代理对象，破坏了单例性
  当二级缓存拿到这个对象后，三级缓存移除对象工厂  




# IOC 

## 什么是IOC

  控制反转，把对象的创建和依赖关系管理权交给spring容器，让容器自己创建对象并注入到对应的依赖中
  这杨可以让业务代码不必创建和对象，告诉了我们应该如何设计系统架构

  ### Di
  DI，依赖注入，IOC思想的具体实现办法。从实现角度看有 setter 构造器和 字段注入
  
  IOC的实现方式还有 Service Locator 模式，服务器定位模式，通过ApplicationContextAware接口获取Spring容器中的Bean
 
 ===========================
  ### 为什么使用IOC？
  我们需要实现一个功能，需要多个对象。传统的方式需要自己new一个，A需要B，AB之间产生依赖，存在了耦合关系。
  有了Spring之后，创建B的工作交给了Spring完成，Spring创建好后放到容器中，A向spring容器请求B，容器就把B取出交给A

  IOC可以降低对象之间的耦合，让业务只关注业务。  
 ===========================
  
  

## IOC实现机制
  
   1. 加载Bean的元信息
      扫描配置的包路径里注解的类，把他们的元信息封装成BeanDefinition对象

   2. Bean工厂的准备，创建一个DefaultListableBeanFactory 作为Bean工厂来负责Bean创建和管理

   3. Bean实例化和初始化。对于单例Bean，Spring会查看缓存中是否已经存在，没有命中就创建一个实例
      属性填充阶段 依赖注入，通过反射字段注入，或者setter注入.

      

## 如何理解IOC？
  
  IOC就向一个工厂，产品是Bean
  
  通过注解告诉工厂生产什么Bean，工厂里面的生产线就是BeanPostProcessor，比如AutowiredAnnotationBeanPostProcessor就是专门负责@Autowired注解

   还有缓存机制存放产品，SingletonObjects 是成品仓库(一级缓存) 二级缓存存放半成品
  
  还能根据依赖关系来决定Bean的创建顺序

  
## 手写一个简单的IOC容器？
  
  IOC容器的主要组成：获取Bean，创建Bean，依赖注入（反射）, 还要有注解，扫描注解

  ```java
  //定义注解
  @Target(ElemetnType.TYPE) //作用目标是类
  @Retention(RententionPolicy.RUNTIME)  //保留策略,运行时保留
  public @interface Component{
    String value() default ""; // 用于指定Bean名称
}
 
  @Target(ElemetnType.FIELD)
  @Retention(RententionPolicy.RUNTIME)
  public @interface Autowired{
    //...
}


  2.//定义IOC容器类，扫描包路径，创建BEan，依赖出入
  
  public class SimpleIOC{
    //一级缓存
    private Map<Class<T>,Object> beans = new HashMap<>();
    
    public SimpleIOC(){
        Set<Class<?>> componentClasses = Set.of(Myservices.class,MyRespository.class)
        
        //实例化所有Bean
        componentClasses.forEach(this::registerBean);

        //注入依赖
        beans.keySet().forEach(this::populateDependencies);

}


    
    /**
     * 扫描并注册组件
     */
    public void scan(String packageName) {
        // 简化版：手动添加需要扫描的类
        List<Class<?>> classes = getClassesInPackage(packageName);
        
        for (Class<?> clazz : classes) {
            if (clazz.isAnnotationPresent(Component.class)) {
                registerBean(clazz);
            }
        }
        
        // 依赖注入
        inject();
    }
    
    /**
     * 获取包下的类（简化实现）
     */
    private List<Class<?>> getClassesInPackage(String packageName) {
        // 面试时可以说："实际实现需要扫描classpath，这里简化处理"
        return Arrays.asList(UserDao.class, UserService.class);
    }

   3. 实例化Bean
  
    public void registerBean(Class<?> clazz){
        try{

            Object instance = clazz.getDeclaredConstructor().newInstance();
            beans.put(clazz,instance);

        }catch(Exception e){
            throw new RuntimeException("创建失败："+clazz.getName(),e);

        }
}

    4. 获取bean
    @SuppressWarning("unchecked") 
    public  <T>T getBean(Class<T> clazz){
        return (T) beans.get(clazz);        
    }

    
   5. 依赖注入

    public void inject(){
        for(Object bean : beans.values()){
        injectField(bean); 
        }
    }


    publci void injectField(Object bean){

        Fields[] fields= bean.getClass().getDeclaredFields();
        for(Field field : fields){
            //检查是否有Autowired 注解的字段
            if(field.isAnnotationPresent(Autowired.class)){
                try{
                    field.sestAccessible(true);
                    Object dependency = getBean(field.getType());
                    field.set(bean,dependency);
                } catch(Exception e){
        
                    thorw new RuntimeException("注入失败:"+ field.getName(),e);
                }

            }
        }

    }   

}

  ``` 


## 说说BeanFactory 和 Applicatoncontext的区别？

  Beanfactory提供了最基础的IOC能力，负责Bean的创建和管理。 采用懒加载的方式

  APplicationContext 是Beanfactory的子接口，提供了很多企业级功能，比如时间发布，AOP，JDBC，ORM 。。。采用饿汉式加载，导致启动时间长一点，但是运行时性能好

 Application会自动调用bean的初始化和销毁方法，BeanFactory需要手动管理。


## 项目启动时IOC做什么？

  1. 扫描Bean组件，根据指定的包路径扫描注解类，把元信息封装到BeanDefinition，注册到 BeanDefinitionRegistry 中。

  2. Bean实例化和注入，根据依赖关系创建bean ，反射构造方法创建实例，属性注入，执行回调。



## bean实例化方式：

  1. 构造器实例化
     使用@component 等注解标注的默认使用构造器创建实例

  2. 静态工厂实例化
     写一个静态工厂方法，用@Bean 标注 spring会根据静态方法获取bean

  3. 实例工厂实例化
     创建工厂对象，通过工厂创建对象的方法来创建对象，@Bean标注对象，@Bean标注对象，@Bean标注对象，@Bean标注

  4. FactoryBean接口实例化 ，
     spring提供这个接口，复杂对象的类实现这个接口就行, 然后重写getObject方法，执行自定义创建逻辑
     


# AOP

## 什么是AOP？
   AOP就是把业务代码的相同部分抽取到一个模块中，简化业务代码（可读性。。。）

  ### AOP的核心概念：
  1. 切面
    定义一个类，用@Aspect(spring) 注解标注，包含什么时候做执行什么逻辑
    通常是要往目标对象插入的功能模块

  2. 切点
   定义为那些地方拦截并执行切面逻辑 。在spring 中只能在方法级别切入,AspectJ 编译器可以任何地方(字段，构造，任何方法)
   @pointcut 定义切点白哦大师匹配方法(spring)

  3. 通知
    具体要执行的代码逻辑，分很多种，代码执行前，代码执行后，执行前和执行后等等

  4. 连接点
    被插入的点，spring中指的是被拦截的方法,因为spring只支持方法上的拦截
  
  5. 织入
    把切面逻辑应用到目标对象的过程 , 也就是如何把模块插入其中的。
    spring因为是运行时代理，所以用的时JDK的动态代理和CGLIB的动态代理

  6. 目标对象(target)
    被切面插入的对象，spring中@Service @Conroller 标注的类

  ### AOP织入的方式（时期）?
   编译期 ，类加载期 ，运行时

   1. 编译时期： AspectJ编译器可以做到，在编译JAVA源码的时候就把切面织入到目标类,直接在Class文件中包含切面逻辑

   2. 类加载期： 在JVM把类加载的时候 ,通过自定义的类加载器/ instrumentation API 实现
                要配置参数使用
   3. 运行时织入： 最常见通过动态代理方式实现 ,spring 发现bean 要被切面处理，就创建一个代理对象，在Bean的初始化过程后期被织入切面逻辑

  
  ### AOP的通知方式

  1. 前置@Before

  2. 后置 @after

  3. 环绕:@Around

  4. 异常通知：@AfterThrowing

  5. 返回通知：@AfterReturning

  多个切面可以用@Order + 数字确定优先级


  ### Spring AOP发生在什么时候？
   Bean初始化的时候，执行BeanPostProcessor的postProcessAfterinitialization 方法就是AOP代理对象创建


## AOP场景：

  高频场景: 事务管理每个项目都会用到，只要在方法上加入@Transactional
            日志记录，打印方法的执行时间，参数等等,后续优化和找BUG


## spring AOP和AspectJ 的区别
  都是用来切面织入目标类的

  两者使用不同的编译器，spring原生javac 
  执行时期不同： spring 在运行时创建代理对象 , AspectJ在程序执行前就已经把代码织入

  拦截级别不同： spring仅能拦截方法 ,AspectJ 可以拦截所有字段，构造器，和所有方法

  作用范围不同： spring仅支持容器内的Bean被代理，AspectJ在所有类上都可以

  速度: AspectJ 快




## spring AOP 和 反射的 区别？

  反射通过调用 java lang refelect 包实现，让对象可以获得自身的类结构信息，调用类的方法和访问字段等等

  AOP在不改变业务代码的前提下，动态添加功能模块代码，实现原来代码之外的功能


## AOP 和装饰器模式的区别？
  
  目的相同，不改变业务代码的前提下，动态添加功能模块代码，实现原来代码之外的功能

  但是装饰器模式要手动编写包装类，spirng AOP 交给容器创建代理对象 

## AOP 的 两种代理方式的区别？

  JDK 代理要 目标类实现一个接口(通过实现接口。)， CGLIGB 不需要实现类(通过继承目标类生成代理对象)

  JDK 代理的实现原理是  创建一个实现了InvocationHandler 的类(调用处理器)，重写invoke方法在反射调用目标对象方法前后插入 切面代码
      创建代理对象的时候把调用处理器传入,代理对象实现目标对象的接口  （java.lang.refelect.Proxy）  
     在调用代理对象的方法，被处理器转发到invoke 方法中，反射调用真实方法

  CGLIB 通过ASM 字节码框架动态生成目标类的子类，重写父类方法的时候插入切面代码


 spring boot > 2.0  默认采用CGLIB 

## 使用JDK动态代理?

  
  1. 创建一个接口

  2. 实现接口

  3. 创建一个调用处理器，重写invoke方法 (切面逻辑插入) //Handler

  4. 创建一个代理工厂，内部维护目标引用。在getProxy方法里 `Proxy.newProxyInstance(target.class().getClassLoader,
                                                                                  target.getClass().getInterfaces()，handler)`

  5. 调用代理对象的方法


## 使用CGLIB？

 1. 创建目标类

 2. 创建代理工厂，定义动态创建代理对象的方法getProxy , 重写 intercept 方法插入逻辑

 3. getproxy 里使用 Emhancer 工具设置父类(反射),设置回调函数，创建proxy。


# 事务


## 对事务的理解？
   事务分为编程式事务和声明式事务。

   编程式事务就是手动编写事务的开始提交回滚。
   声明式事务只需要加上@Transactional注解就好

   @Transactional 执行业务逻辑之前就要获取事务属性，隔离等级等等属性。然后通过事务管理器开启一个新事务，并拿到一个数据库连接池当中的连接
   关闭其自动提交

   执行业务逻辑后提交事务。若抛出异常，拦截器捕获并让事务管理器回滚事务，撤销所有操作 

  ### 事务失效的场景
   1. 注解标注在非public方法上，可能无法由代理对象实现该方法，或者无法继承该方法。

   2. 方法内部调用的时候，由方法A调用 被标注的方法B，因为要通过this指针寻找方法调用，this指针拿到的是原始对象，绕过了代理对象
      ==直接通过代理对象调用方法== 需要内部维护一个Bean，从容器中拿到代理对象再调用方法 

   3. 事务内部 try-catch块 捕获异常但是没有throw抛出，事务拦截器是通过异常对象感知的，没有throw抛出他就感知不到,也就无法回滚

   4. spring 默认只对RuntimeException 和 Error 异常回滚，如果抛出的异常不在这个范围中，就无法感知到异常，事务不会回滚 
        指定异常 rollbacker = Exception.class


> Throwable  | -- Error
             |
             |                   |--- IOException  ---FileNotFoundException
             | -- Exception  ----|
                                 |                      |---- 空指针异常j
                                 |--- RuntimeException  |
                                                        |---- 数组越界异常
                                                        |
                                                        |---- 非法参数异常
                                                        |
                                                        |---- ClassCastException

## 事务的隔离等级？

   事务的隔离等级定义一个事务可以接收其他并发事务影响的程度。也就是能不能和其他并发事务一起执行

   SQL隔离四等级：
   1. 读未提交
        读未提交的事务，会发生脏读，幻读，不可重复读
                    脏读：未提交的事务的数据被读取，如果事务提交失败，读到的就是脏数据
                     幻读： 查询包含未提交事务的数据，事务提交失败，多次查询的数据数量不一致
                     不可重复读： 读完事务的数据后 事务的数据立刻被修改

   2. 读已提交
        脏读的情况不会发生
   3. 可重复读
         Mysql 通过MVCC 实现，事务启动时创建读视图，保存当前所有事务的ID。读的时候就读的这个版本的快照 ,能读的也是这些事务的数据
        但是由幻读问题仍有，这是多事务并发的最难解决的点，需要用到锁。
   4. 串行化
      最高等级，所有事务串行执行，高数据敏感的的场景使用。并发效率及其低 

> mysql 解决幻读问题:
> 间隙锁，事务都这些数据行 上锁，另一个事务要修改这这些行的数据要枪锁，抢不到就阻塞，所释放才能提交


## spring 事务传播机制》？

  spring定义了7种传播行为，
  1. Required   当前有事务就加入，没有就新建一个事务
  2. Supports   ~ ，没有事务就非事务方式运行
  3. Mandatory  ~， 没有事务就抛出异常
  4. Required_New  总是创建新事物,有事务暂停
  5. Not_Supported  非事务方式运行，当前有事务就暂停，执行完恢复
  6. Nested   支持嵌套事务，子事务失败回滚，外部事务失败全失败

 事务传播是通过ThreadLocal实现的，无法跨线程传播

  默认Required



# spring MVC

## Spring MVC 的核心组件？

  前端控制器 DispatcherServlet ，核心调度器，负责将请求分发到响应的Controller ,比如用户管理就分发到UserController
  
  处理器映射 HandlerMapping  负责将URL解析 ，找到对应的Controller，告诉 前端控制器应该把请求交给哪个方法处理

  处理器适配器 HanlderAdaptor 负责调用该处理器的方法，处理参数绑定(把请求里的参数传入handler中)，类型转换等等

  视图解析器 ViewResolver 解析返回的视图对象

  异常解析器 HandlerExceptionResolver 捕获并处理抛出的异常 。 通常使用 @ControllerAdvice 和 @ExceptionHandler 自定义处理逻辑

  文件上传解析器 MultipartResolver  处理文件上传

  请求拦截器 HandlerInterceptor  对请求执行之前做额外的逻辑，比如鉴权和登录校验

## Spring MVC 工作流程

  用户产生Request请求，请求经过 前端控制器后查找Handler(Controller里的方法),由 HandlerMapping 路由匹配到handler 
  前端控制器委托 HandlerAdapter 进行调用，处理结果并参数绑定，类型转换。 一般使用RequestMappingHandlerAdapter ,注解驱动开发。 
  controller返回最终结果，返回视图就让前端控制器调度 视图解析器解析。返回Json数据就直接返回客户端

  **==HandlerAdapter 的存在是为了解决 前端控制器硬编码调度handler的问题==**

    传统方式每新增一种controller ，就要添加前端控制器响应的调用逻辑
    将这些调用逻辑抽取出来放到专门的 Adapter中 ，提供统一的调用入口
   
    实现了Controller接口的就用SimpleControllerHandlerAdapter
    @RequestMapping注解的就用 RequestMappingHandlerAdapter 。

## RESTful 风格的接口执行流程
    
   RESTful 架构要求直接返回JSON数据或xml
  spring MVC 通过 @RequestBody 注解要求controller 返回的对象直接作为响应体的内容
   Controller返回的是一个JAVA对象，要作为JSON或XML 返回客户端要序列化 。HTTPMessageConverter 

   RESTful 接口执行流程就是最后无需视图解析，直接交由HTTPMessageConverter 转换成JSON返回客户端


# spring boot

## 介绍spring Boot
 
  基于spring的框架，简化了spring的配置和搭建过程

  **核心理念**：
    约定大于配置：预设很多默认配置 ，tomcat logback等等，无需专门配置

  **自动装配**：
    根据项目引入的依赖自动配置合适的Bean
    比如spring security spring boot自动配置安全相关的Bean

## boot自动装配的原理 
  启用自动配置的注解@EnableAutoConfiguration,扫描自动配置类

  spring Boot 项目启动时，加载所有的自动配置类，逐个检查生效条件，符合条件就创建Bean
  自动装配的时机在 spring容器启动时，ConfigurationClassPosstProcessor 这个BeanPostProcessor处理的，解析@Configuration 类和@Import导入的

  
## Spring boot stater 原理

  starter把相关依赖打包，在pom引入stater ， maven自动解析starter 的依赖树，下载jar包。
  starter都会有自己的自动配置类 ， 通过条件注解判断(@ConfigurationOnMissingBean 注解可以确保首先加载自定义的bean,也是boot用户配置大于默认配置的原则)是否生效
  在每个stater中META-INF 目录中有spring.factories文件，存放自动配置类，boot启动时读取这个类，加载对应的配置类

  **手写stater**：
 1. 定义一个自动配置类，要把根据配置文件创建Bean  。需要注解@Bean @ConditionalOnMissingBean
 2. 写配置属性类，@ConfigurationProperties 标注
 3. 写一个Bean类，提供业务逻辑。
 4. 在sprig.factories文件中加入自动配置类，pom添加这个starter
> boot 3 是AutoConfiguration.imports 文件
## spring boot 启动原理？
  两个核心：@SpringApplication 注解 和 SpringApplication.run()

   注解主要标注这是spring 配置文件，扫描当前包和子包组件([[如何理解Bean]])注册Bean  
    
  run 方法 创建 SpringApplication 实例，并识别应用类型 ， 创建ApplicatonContext(IOC容器) ，把主类当配置源加载 ； Bean实例化(Scan包的Bean组件)
            触发自动配置;启动web服务器

## spring boot 和 spring  ,spring MVC的区别？
  spring 是完整的应用开发框架，提供IOC AOP 等模块
  spring boot 是依赖于spring的一个框架,简化配置和引入依赖

  spring 要手动管理 每个jar包的版本，还要保证版本兼容 。 spring Boot通过starter引入所有相关依赖，并保证了版本的兼容性
 
  spring MVC 是spring的一个模块，专门应对web开发的请求处理和响应。
  boot 为web开发提供默认配置(前端控制器。。。),无需手动配置，简化项目部署

# spring Cloud

## 什么是spring Cloud
  基于boot的微服务全家桶，把分布式的基础设施做了封装，配置管理，负载均衡，熔断限流，链路追踪等 拿来即用

  ### 什么是微服务？
  把一个大单体应用拆分围绕业务独立部署的小服务 ，每个服务维护自己的逻辑和数据，服务之间通过gRPC等轻量通信机制通信



# springTask
  轻量的任务调度框架，允许开发者通过注解管理和配置定时任务
  @EnableScheduling

  默认单线程。某个任务执行时间长或任务多就会阻塞。
  配置线程池来执行，或者迁移到其他任务调度框架 QuartZ XXL-JOB
# springCache
  缓存抽象，用统一接口支持多种缓存实现
  @EnableCaching 启用缓存
  @Cacheable(key ,value) 缓存结果
  @CacheEvict() 方法执行前或后删除缓存

  基于AOP实现，通过拦截方法调用插入缓存逻辑。
  **好处**：
 1. 提供一套统一的接口和注解管理缓存，并不具备缓存能力，需要在配置类里配置缓存容器。他是抽象层，和具体的缓存实现无关
 2. 灵活切换底层实现


  ### 底层：
  调用被注解的方法时，经过代理对象调用相应方法，代理对象的拦截器解析缓存注解，根据注解选择不同的缓存策略
  缓存key 通过keyGenerator 组件 默认根据方法的参数生成key，如果注解指定了key，spring 根据SpEL表达式引擎解析表达式，根据上下文信息计算key值
  底层缓存靠 CacheManager , Cache 抽象接口实现，CacheManager管理多个缓存区，cache实例对应一个缓存区

