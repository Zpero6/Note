## 何为 DML

SQL语言分四大类:

- DML(Data Manipulation Language)  数据库操纵语言
  
  > insert
  > 
  > update
  > 
  > delete

- DDL(Data Definition Language) 数据库定义语言
  
  > create table/index /view / cluster(簇) / syn( 同义词)
  > 
  > alter 

- DCL(Data Control Language ) 数据库控制语言
  
  > grant 授权
  > 
  > rollback 回滚
  > 
  > commit 提交

- DQL(Data Query Language) 数据库查询语言
  
  > select
  > 
  > from
  > 
  > where

*前文讲到的 `alter` 属于==DDL==语言 ,改变了表的结构*

## DML 操作

**添加数据**

```sql
insert into  students(id , name , score_rank,teacherid) values(
    001,  '张三', 001, 001 
) ;
```

> [!NOTE]
> 
>  上面的可以自定义要填入那一列的数据,但是要求不能为null ,例如
> 
> ```
> insert into  students(id , name , teacherid) values(
>     003,  '王五',  001 
> ) ;
> ```
> 
> *score_rank默认填充==null==*

```sql
insert into students values(002,'李四' , 002,001);
```

> [!NOTE]
> 
>  也可以填入null,但是一定是==没有非空约束==的字段
> 
> ```sql
> insert into students values (004, '赵六',null,null);
> ```
> 
> **虽然是外键也可以为空**
> 
> 或者默认值处理(这里没有设置默认值,可自行设置)
> 
> ```
> insert into students values (004, '赵六',default,default);
> ```

**更新数据**

```sql
update students set score_rank = 3,teacherid = 1 where id = 003; 
```

> [!WARNING]
> 
> 一定写where 条件,否则表中所有数据都将被更新

**删除数据**

```sql
delete from students where id = 005;
```

**删除表中所有数据**

```sql
truncate table students;
```

或者

```sql
delete from students;
```

> [!TIP]
> 
> **delete 和 truncate 的区别**
> 
> truncate 整体删除表中所有记录,不写log,属于==DDL语句==
> 
> delete 逐条删除 写log 效率比truncate低,属于==DML语句==

## *附录*

### truncate 工作原理

1. **DDL操作本质**
   - truncate被归类为DDL ,而非DML
   - 实际上是先drop表,再create一个新的表,而非逐行删除
   - 由于是完全新建表,自增值会完全重置
2. **性能优势**
   - 不触发trigger
   - 不检查外键约束
   - 不记录单行删除

### delete 工作原理

1. **DML本质**
   
   一行一行执行删除

2. **执行过程**
   
   - mysql为每行记录生成undo日志(用来回滚)
   - 在InnoDB的聚簇索引中标记记录为已删除
   - 不修改内存中保存的自增值计数器
