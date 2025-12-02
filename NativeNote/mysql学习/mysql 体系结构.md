## mysql 体系结构

- 连接层

  - 连接池

  - 认证模块

  - 线程管理

    **功能**

    - 处理客户端的连接请求
    - 身份验证和权限检查
    - 维持和管理连接线程
    - 提供通信协议支持(tcp/ip , unix socket)

-  服务层(sql接口和解析优化)

  - sql 解析器

  - 查询优化器

  - 缓存管理器

    **功能**

    - 接收SQL语句并解析
    - 检查语法和语义
    - 生成执行计划
    - 查询缓存管理
    - 预处理语句支持

-  引擎层

  - 插件式架构,支持多种存储引擎
  - 每种引擎都有不同特性和使用场景

-  存储层

  - 数据文件 .ibd(InnoDB) .myd(MyISAM)
  - 索引日志   .myi(MyISAM )
  - 日志文件 
    - redo log 重做日志
    - undo log 撤销日志
    - bin log 二进制日志
    - error log 错误日志
    - slow query log 慢查询日志
    - my.cnf / my.ini 配置文件
    - pid-file  进程ID文件

<img src="https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507121143947.png" alt="image-20250712114322907" style="zoom:150%;" />

## MySQL 存储引擎

存储引擎是<mark>基于表</mark>的而不是基于 数据库的 , 也被叫做 *表类型*



```sql
show create table students;
DESCRIBE students;    
show engines;
```

![image-20250712120519873](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507121205115.png)

![image-20250712124053780](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507121240937.png)

![image-20250712121841116](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507121218588.png)

auto_increment 的值是即将插入的数据的id

可以看到默认引擎是 InnoDB

早期MySQL的默认引擎 MyISAM



```sql
-- 创建表指定存储引擎
create table  book (
	id int  zerofill not null auto_increment primary key,
    name varchar(50) ,
    price int
)engine = MyISAM;
show create table book;
```



## InnoDB

InnoDB 是一种高可靠性和高性能的通用存储引擎,在mySQL 5.5 之后 ,被设置为了默认存储引擎

**特性**

- DML 操作遵循ACID模型(事务的四大特性),支持事务
- 行级锁 , 提高并发访问性能
- 支持外键 FOREIGN KEY 约束 ,保证数据的完整行和正确性

> **行级锁:** (类似c++中的 mutex)
>
> 就像图书馆自习室：每个人可以单独预订一个座位（一行数据），其他人不能占用你预订的座位，但可以预订其他座位
>
> **两种基本锁**
>
> 共享锁(读): 多人同时读一个文件,但是不能写
>
> 排他锁(写): 同一时间只能有一个人写数据
>
> **行级锁的必要性:**
>
> <mark>避免争抢文件导致的数据竞争 , 降低效率</mark>
>
> 提高效率

在你的MySQL安装目录下 (博主是 `D:\mysql8\Data`)

![image-20250712123300203](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507121233251.png)

可以发现,InnoDB 的表文件只有一个 以`.ibd` 后缀的文件

MYISAM 则有多个 `.MYD` 数据 `.MYI`索引  `.sdi` 替代原来的 `.frm` 存储表结构

如何查看数据?

```Command
-- 新建命令行 , 我这里用到是 powershell
cd {你的数据库存储文件目录}
cd D:\mysql8\Data\mssqldata
cat book_462.sdi
# 使用idbsdi工具
ibd2sdi students.ibd
```

读到的都是json格式数据

![image-20250712124834289](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507121248973.png)

![image-20250712124917609](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507121249438.png)

 **InnoDB存储特点**

![image-20250712125152641](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507121251731.png)

page是磁盘操作的最小单元 ,大小是16k

每个page大小是1M , 可以包含 64 个 page
