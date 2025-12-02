## 何为约束

数据库约束是对表中数据进行进一步的限制,保证数据的正确行,    有效性和完整行

## 约束有哪几种

1. 主键约束 primary key

   > 主键约束是使用最频繁的约束.
   > 
   > 在设计数据表时,一般都会要求设置一个主键.主键是表的一个特殊字段,能唯一表示表中的每条记录.要求不能为null,且所有值都是该表唯一的 

2. 外键约束 foreign key

   > 外键约束经常和主键约束一起使用,用来确保数据的一致性
   > 

3. 唯一性约束 unique

   > 唯一约束和主键约束都可以唯一确定一条记录,即都有唯一性.
   >
   > 但是唯一约束在一个表可以有多个,并且可以允许是null

4. 非空约束 not null

   > 非空约束要求表中的字段不能为空

5. 检查约束 check

   > 检查约束,又叫用户自定义约束,是用来检查表中字段值是否是有效的. mysql数据库不支持检查约束



## 主键约束

> [!TIP]
>
> students 是博主的表名,使用时可以替换为自己设置的表名

**添加主键约束**

```sql
alter table students add primary key (id);
```

**删除主键约束**

```sql
alter table studentes drop primary key;
```

**主键自增长**

> 在数据库表中，当插入新记录时，主键字段的值会自动递增，无需手动指定
>
> 通常用 `auto_increment` 关键字表示

- 一个表只有一个列为自动增长
- 自动增长必须是整数类型
- 自动增长只能添加到具备主键约束 和唯一性约束上

```sql
alter table students modify id int auto_increment;
```



> [!WARNING]
>
> 当主键自增长时要删除主键约束,要先删除自增长,在删除主键约束

 

## 外键约束

**添加外键约束**

> [!NOTE]
>
> 这需要另一张表

```sql
create table teacher(
	id bigint primary key  comment '教师id',
    tname varchar(200) not null comment '教师名称',
    age int not null comment '年龄'   
);
```

```sql
alter table students add column teacherid bigint ;
```



``` sql
alter table students add constraint teacherId foreign key(teacherid) references teacher(id);
```

**删除外键约束**

```sql
alter table students drop foreign key teacherId;
```





## 唯一性约束

**添加唯一性约束**

```sql
alter  table  students add constraint name_uk unique(name);
```

**删除唯一性约束**

```sql
alter table students drop key name_uk;
```



## 非空约束

 **添加非空约束**

```sql
alter table students modify name varchar(10) not null;
```

**删除非空约束**

```
alter table students modify name varchar(10) null;
```





## 查询约束

```
show keys from students;
```

