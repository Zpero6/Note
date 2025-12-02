##  什么是事务

事务是<mark>一组操作的集合</mark>,他是一个<mark>不可分割</mark>的工作单位,事务会把所有的操作作为一个整体一起向系统提交或撤销操作请求 ,这些操作要么同时成功,要么同时失败(回滚事务)

>  事务只和DML有关

**创建 account 表**

```sql
create table account (
	id int auto_increment primary key comment '主键id',
    name varchar(10) comment '姓名',
    money int comment '余额'
) comment '账户表';

insert into account(id , name , money) values (null,'张三' , 2000) , (null,'李四' ,2000);
```



## 事务的流程

一个简单的转账例子

```sql
update account set money = money -1000 where name = '张三';
update account set money = money + 1000 where name = '李四';
```



![image-20250711171236701](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507111712775.png)



## 事务操作

- 查看/设置事务提交方式

  ```sql
  select @@autocommit;
  set @@autocommit = 0;
  ```

  设置为0 手动提交 ,设置为1 自动提交

- 提交事务

  ```
  commit;
  ```

- 回滚事务

  ```sql
  rollback;
  ```

  ```sql
  -- 1. 确认自动提交关闭
  SET @@autocommit = 0;
  SELECT @@autocommit;  -- 应该返回0
  
  update account set money = 2000 where name = '张三' or name = '李四';
  commit;
  
  -- 2. 开始事务（可选，明确表示事务开始）
  START TRANSACTION;
  
  -- 3. 执行更新
  UPDATE account SET money = money - 1000 WHERE name = '张三';
  UPDATE account SET money = money + 1000 WHERE name = '李四';
  
  -- 4. 查看当前数据（应该已修改）
  SELECT * FROM account;
  
  -- 5. 回滚
  ROLLBACK;
  
  -- 6. 再次查看数据（应该恢复原状）
  SELECT * FROM account;
  
  -- 7. 如果需要提交
  COMMIT;
  select * from account;
  
  ```

  -  一定要设置 autocommit = 0;
  - 设置手动提交后,做出的改变要保存一定要commit;
  - 最好显式使用 start transaction;

  ​          

## 事务的四大特性

- 原子性: 事务是不可分割的
- 一致性 : 事务完成时,必须让所有的数据保持一致状态(上述例子余额总数恒定)
- 隔离性: 数据库系统提供的隔离机制,保证事务不受外界并发操作的影响
- 持久性: 事务一旦提交或回滚,数据库的数据改变是永久的



## 事务的并发问题

事务并发问题指的是当多个事务<mark>同时访问和操作数据库</mark>时可能引发的一系列问题.

**主要问题**

**脏读**

一个事务读取了另一个未提交事务修改过的数据

为了演示,开了两个console ,先看隔离级别 部分

```sql
-- left window
set session transaction isolation level read uncommitted;

```

```sql
-- right window
start transaction;
update account set money = money - 1000 where name = '张三';

```

```sql
-- left 
select * from account;
```

![image-20250711180759117](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507111807587.png)

在  事务的隔离条件为 read uncommitted 时 , 左右窗口任何一个改变对于数据库中的数据都是<mark>持久性的</mark> , 你的任何一次dml操作都会影响

其他并发窗口的查询结果, 换言之 , <mark>任何一次修改对于数据库来说都是永久的影响</mark> , 



**不可重复读**

一个事务先后读取同一条记录,两次读取的数据不同 

```sql
-- left
set session transaction isolation level read committed;
start transaction;
select * from account;
-- right 事务进行完后 
select * from account;
```

```sql
-- righ
start transaction;
update account set money = 5000 where name = '张三';
commit;
```



![image-20250711201116214](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507112011495.png)

表被设置为 read committed, 避免了脏读的可能  . 但是right window 事务提交前后 在left window 查询到的表数据不一致,说明在 right window 做出改变影响到了left window 数据的查询  .  较之脏读 , commit 成为了改变数据库里数据的条件



**幻读**

一个事务按照条件查询数据时,没有对应的数据行,但是在插入数据的时候,发现这行数据又存在了

```sql
-- left
set session transaction isolation level repeatable read;
commit;

start transaction;
select * from account;
-- right 第一次事务完成后
select * from account;
```

```sql
-- right 第一次事务
start transaction;
update account set money = 8000 where name = '张三';
commit;
```

![image-20250711202741151](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507112027409.png)

发现 right window事务提交后 left 查询到的结果是相同的 , 只有当左边commit 之后,才能显示right window 修改后的表;

![image-20250711203019952](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507112030069.png)



**那么什么是幻读呢**

```sql
-- left
start transaction;
select * from account;
-- right 事务结束后
insert into account(id , name , money) values(3 ,'王老太' , 6000);
select * from account;
```

```sql
-- right
start transaction;
insert into account(id , name , money) values(3 ,'王德发' , 6000);
commit;

```

![image-20250711203904012](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507112039164.png)

在right window是可以读到的,<mark>说明repeatable read 可以读到事务自己修改的数据</mark>>

![image-20250711204817038](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507112048136.png)

可以看到主键重复了,right window提交后表里已经有了id 为3 的数据了,但是left window 只能知道有这么一条数据存在,但是无法读取到 , 

因为repeatable read 在并发中限制了只有双方都commit后才可以读取到. 详情见文末



## 事务的隔离级别

|         隔离级别         | 脏读 | 不可重复读 | 幻读 |
| :----------------------: | :--: | :--------: | :--: |
|     read uncommited      |  ✓   |     ✓      |  ✓   |
|      read commited       |  ✕   |     ✓      |  ✓   |
| repeatable read(default) |  ✕   |     ✕      |  ✓   |
|       serializable       |  ✕   |     ✕      |  ✕   |

**查看事务隔离级别**

```sql
select @@transaction_isolation;
```

**设置事务隔离级别**

```sql
set [session| global] transaction isolation level{read uncommitted|read committed| repeatable read| serializable}
```

## repeatable read 的原理

Repeatable Read（可重复读）是MySQL InnoDB引擎的默认事务隔离级别，它通过特定的机制确保在同一事务中多次读取相同数据时能得到一致的结果，从而避免了不可重复读的问题。

### 实现机制

#### 1. 多版本并发控制 (MVCC, Multi-Version Concurrency Control)

InnoDB使用MVCC来实现Repeatable Read隔离级别：

- 每行记录都有两个隐藏字段：
  - `DB_TRX_ID`：记录创建或最后一次修改该行的事务ID
  - `DB_ROLL_PTR`：指向该行在回滚段(undo log)中的历史版本
- 每个事务启动时会被分配一个唯一的事务ID
- <mark>事务只能看到以下数据</mark>：
  - <mark>事务开始前已提交的数据</mark>
  - <mark>本事务自身修改的数据</mark>

#### 2. 一致性读视图 (Consistent Read View)

在Repeatable Read级别下：

1. 事务在**第一次执行SELECT查询时**会创建一个"读视图"(read-view)
2. 这个读视图会记录：
   - 当前活跃的事务ID列表（未提交的事务）
   - 最小活跃事务ID
   - 下一个将要分配的事务ID
3. 后续所有SELECT操作都基于这个**固定的读视图**，而不是实时数据

#### 3. 具体实现过程

当执行SELECT查询时：

1. 检查行的`DB_TRX_ID`
2. 如果`DB_TRX_ID`小于当前事务ID且不在活跃事务列表中 → 可见
3. 如果`DB_TRX_ID`在活跃事务列表中 → 不可见（该修改尚未提交）
4. 如果`DB_TRX_ID`大于等于下一个将要分配的事务ID → 不可见（该修改在事务开始之后发生）
5. 如果不可见，则通过`DB_ROLL_PTR`找到undo log中的合适版本