 

## 使用JDK8的优点是什么？

  **更简洁的代码 ，强大的抽象能力，更好的并行处理和 更强大的API**：

  1. 函数式编程支持
        Lambda 表达式 允许将函数作为参数 或者代码本身作为数据，简化了匿名内部类的写法

        函数式接口 ： lambda表达式的基础，任何只有一个抽象方法的接口都是函数是接口，并使用@FunctionalInterface 标识
                        内置 Function ，Predicate

  2. 提供强大且高效的批量操作数据的能力
        Stream API : 对于集合元素进行函数式、声明式的处理（过滤 映射 排序 聚合）
            声明式编程： 说明你想要什么，不用关心怎么做
            链式操作： 将多个操作串成一个管道，使代码流畅易读。（Stream 内部迭代，无需手写for循环）
            并行能力：将 .stream()替换成 .parallelStream() 就可一实现并行处理

  3. Optional类：
        解决空指针异常的容器类 
            避免控制指针异常， 
            避免深层嵌套（判断空值逻辑）, 代码更健壮


> 如何创建Optional 对象？
> 1. Optional.empty() 创建空optional 
> 2. Optional.of(T Value)   创建包含非空的Optional ，传入空值会抛出异常
> 3. Optional.ofNullable(T Value) 最常用。控制创建空的Optioanl。否则就包含该值 

  4. 引入现代且线程安全的日期和时间API
        Localdate  LocaLTime  LocalDateTime ...
        所有类都不可变，API设计更清晰易用
        
  5. 提升JVM性能并增强并发支持
        默认方法：允许在接口添加具有默认实现的方法
            `default T methodName （）{ 。。。}` 
        静态方法： 允许定义静态方法，无法被 @Ovverride 重写


## 集合和 流有何不同？
  **集合** ：

  内存中的数据结构， 存储和持有数据

  **流**：

  不存储元素，定义了一个对数据源 执行操作的管道 .
  中间操作 返回一个新的流  ，终结操作触发计算，计算后的流被消耗掉不再使用
  可以实现并行处理

  |  特性  |  集合 Collection  |   流Stream    |
  |--------| ------------------| --------------|
  |核心目的| 存储所有数据      | 不存数据，仅作传输管道|
  |主要特征| 立即计算和存储元素| 延迟执行，中间操作不计算|
  | 使用次数| 多次使用         | 仅使用一次         | 
  | 数据修改| 可以被修改       | 不可被修改     | 
  | 迭代方式| 外部迭代，由用户控制|  API内部完成迭代|
  | 并行能力| 用户自定义       | 可以简单并行 |
  | 数据量  |  有限           |  可以表示无限个 |

## Lambda 表达式
  **定义** 
  简洁的匿名函数 ， 可以被传递
    
  没有方法名称，是函数，有参数列表，函数体和返回类型

  **语法**：
 （参数列表） -> 表达式 ；  // 省略return
  （参数列表） -> { 函数体 }；
    

## Predicate 和 Consumer 函数式接口
  ### Predicate 接口
  定义一个判断 ， 返回一个boolean 值


```java
public static void main() {
    Predicate<String> startWithJ = s -> startWithJ("J");
    Predicate<String> longerThan4 = s-> s.length() >4;
    //Stream过滤
    List<String> results = stringSet.stream().
                            filter(startWithJ.and(longerThan4))'
                            .collect(Collector.toList());
    System.out.println("result is " + result.toString());
}
``` 
  ### Consumer 接口
  代表一个消费操作， 接收参数但是不返回任何值
  **抽象方法**：

  void accept(T t)
  java.util.function.Consumer

  **默认方法**：
    
  andThen(Consumer after) 返回一个组合的Consumer ,限制性当前操作，在执行after操作。 是一连串的消费行为

```java
public static main(){
    Consumer<String> toUpperChar = s-> s.toUppeCase();
    Consumer<String> printConsumer = s-> System.out.Println("after Upper" + s);
    
    Consumer<String> comsumerset = Consumer.andThen(printConsumer);
    stringSet.forEach(consumerSet);
}
```
  <Strong> predicate 用来判断数据   Consumer用来遍历和处理数据</Strong>


## peek方法 （） 在 JDK 8中的作用？
    
  **peek方法**：
  StreamAPI 的一个中间操作方法，用来调试和观察流的处理过程中元素状态的变化

  **优点**：
   
  1. 无副作用 ， 不改变流中的元素
  2. 延迟求值
  3. 调试过程不会中断流的执行过程

  **是中间操作，需要终止操作执行**
  适用于临时调试和日志记录

## 什么是函数式接口？
    
  **定义**：
  为了引入lambda 表达式引入的概念， 有且仅有一个抽象方法

  **特性**:
  1. 只有一个抽象方法和若干的默认方法和静态方法
  2，@Functional 注解显著标识，编译期检查是否符合函数式接口的定义

  **为什么使用**：
  取消对匿名内部类的使用，让Lanbda表达式保留唯一抽象方法 以便编译器自己推断出是在实现这个方法

  **JDK8内置函数式接口**：
  1. Function ‘T，R’ 接收T类型的参数， 返回R类型结果
        R apply(T t)
  2. Consumer 'T' 接收T类型参数 但不返回结果
        void accept(T t);
  3. Predicate(T) 接收 T 返回 boolean
        boolean test(T t);


## 接口静态方法的作用
  
   提供工具方法 ，避免额外创建工具类
   代码组织清晰，减少辅助类
   防止类重写 ，静态方法只能通过接口调用，不会被重写和继承
   

## skip(long)  和 limit(long) 的区别？
  都是StramAPI 的中间操作
   skip 是跳过元素的数量
   limit 是保留的最大元素数量
    
  **用法**：
  都是短路操作，处理无限流
  可以组合实现分页功能 skip((page -1)*size).limiit(size);
  

## 抽点类和接口的 异同？
  
  #### 相同：
  都提供了实现多态的方式

  #### 不同：
  
 | 特殊  |  抽象类               |  接口                        |
 | ------| -----------           | ----------                   |
 | 本质   | 作为一个具体的类，走继承| 作为一个接口，走实现
 | 内涵方法| 有抽象方法和具体方法| 抽象方法，默认方法和具体方法|
 | 成员变量| 所有类型的成员变量 | 只能public static final |
 | 构造器 | 有                  | 没有                   |
 | 继承   | 单继承              | 多实现                |
 |多态实现 | 父类引用指向子类对象| 接口引用指向实现类对象|
 | 访问方法| 四种皆有           | public                |
 |设计目的 | 是哪类从属        |  具有什么能力          |


## overload 和 Override 
  **overload** 
   重载行为 ，发生在重载成员方法的场景中 ， 参数类型和返回类型 有一个需要和之前不同 ， 可以重载访问修饰符 和 自己的异常抛出

  **override**：
  重写行为 ，发生在父子类或继承关系之间， 参数类型和返回类型必须相同(返回类型可以是子类)， 访问修饰符不能比父类严格，异常抛出不能比父类宽泛

  **绑定方式**：
    override 使用动态运行绑定，overload 在编译时静态绑定
   
    overload的目的是增加灵活性 ， override 为了实现多态性（方法有不同的指向）

    重载的目的时创建多个同方法名实现同名不同功能。提高代码的可用性
    重写重新定义实现方法，提供专属的实现功能（多态型）

## HashMap 的变化？
    
  1. 引入红黑树
        JDK8 以前采用数组 + 链表 处理hash 冲突 , 链表过长查询效率下降到 O(n)
        JDK 8 编程 数组+ 链表 + 红黑树 。 链表长度到达阈值（8）,数组到达最小树化容量（64）, 链表编程红黑树， 时间复杂度O(n);

  2. 简化Hash算法
    java 8 简化了hash 的计算过程，保证散列性 提升计算效率

  3. 从头插法变成尾插法
     Java 8 改为了尾插法 ，保证原始节点的顺序

  4. 扩容机制的优化
     扩容数组总是翻倍，元素移动到 是原来索引处+oldCap 处。 只需要判断高位的比特值

  5. 功能增强
      引入forEach ，putIfAbsent , compute 等方法，使得操作简洁高效


  **HashMap 通过引入红黑树优化数据结构和改变hash 计算的办法 解决了哈希冲突和性能瓶颈，拥有了稳定的性能表现**


## HashMap  LinkedHashMap  HashTable ConcurrentHashMap 区别

   #### HashMap 
   非线程安全，允许null 无序 高效
    
   #### LinkedHashMap
   继承字LinkedHashMap ， 增加了双向链表 ，维护元素的插入和访问顺序

   #### HashTable
   古老 线程安全的类 所有公共方法上添加 Sychronized（全局锁） 并发效率低 
   HashMap 数组加链表  不允许null值
   #### ConcurrentHashMap 
   高并发 高性能 线程安全
   JDK8 后采用CaS + 重锁 （锁当前链表的头节点 或红黑树的头节点）锁粒度更细 ，性能高
  
   不允许null值
   
   **性能高低**：
   HashMap 最高，但是线程不安全。LinkedHashMap 低于HashMap ,ConcurrentHashMap 也低于HashMap ,但都高于 HashTable
   并发同步下 ， ConcurrentHashMap 最高

## throw 和 throws 的区别

   throw 抛出具体的异常对象 ，throws 声明可能出现的异常类型
   throw 位于方法体内部 ，执行抛出异常 ,可以定义 异常处理语块
   throws 位于方法签名 ， 方法只能使用一次，但可以声明多个异常 

   #### 是否会创建异常对象
   throws 不会创建异常对象， 只是告诉调用者可能会产生什么类型的异常，当异常发生的时候不产生异常对象。
   

## finalize（） 方法
   Object 类定义的一个方法，所有JAVA对象都继承这个方法 。 
   当垃圾回收器确定该对象不可达，执行finalize()方法 。 finiliaze（）后仍不可达确认为可以回收。


## Colllection 和 Collections
   colection 是 接口，定义了集合的基本操作（add,remove,size）,不能直接实例化，依靠实现类的实例化
   Collections 是 工具类， 提供了操作集合的静态方法 ， 没有私有构造函数，不能实例化

   
##  ArrayList  LinkList Vector 的区别
  1. ArrayList 和 Vector 都是动态数组实现的，仅是内存中的一段连续空间 随机访问（索引实现）查询块，但是插入慢，插入要移动后续所有元素
  2. LinkedList 基于双向链表实现 ， 查询慢但是插入快 ，只需要改变相邻节点的引用

  3. ArrayList 和 LinkedList 是非线程安全的， 没有同步开销所以性能高，需要手动同步
  4. Vector 是线程安全的，所有公共方法都是用了 synchronized 关键字，线程同步

  5. ArrayList 默认扩容1.5倍 ， vector默认扩容 2倍 

  6. vector 是遗留类，性能表现差

  **使用建议**：
  1. 大多数情况使用ArrayList ，通用高性能随机读取为主
  2. 频繁插入用LinkedList 
  3. 避免使用Vector ， 多线程中的高性能列表使用 Collections.sychronizedList(new ArrayList()) 或者更高级的并发集合 CopyOnWriteArrayList


## String StringBUffer stringBuilder
 
  1. String 是不可变类，线程天然安全 ，底层是Final修饰的字符数组
  2. StringBUffer 是可变类， 线程安全但是性能低(公共方法用sychronized 同步) ，长度可变
  3. StringBuilder 是可变类， 非线程安全，本质是长度可变的字符数组 ，单线程环境下使用



## ==和 equals 的区别

  1. == 比较基本类型的值，比较引用类型的内存地址
  2. equals 比较两个对象的内容 

  **比较的对比**：
  == 比较内存地址 ，比较的是基本类型，比较的是字面值 ；比较引用类型，只会对比两个的内存地址是否一致
  
  equals 比较的是两个引用类型的值，是Object的一个方法，所有类继承并且可以重写equals()

  **使用建议**：
  比较基本类型用== 比较引用类型用equals（）


