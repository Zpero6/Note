## 何为索引

索引是帮助MYSQL 高效获取数据的数据结构(有序的),在数据之外,数据库系统还维护着满足特定查找算法的数据结构,这些数据结构以某种方式引用 (指向的)数据 , 这样就可以在这些数据结构上实现高级查找算法.



MySQL 的索引是在引擎层实现的,不同的引擎有不同的结构

|    索引类型    |                             描述                             |          支持引擎          |           适用场景           |
| :------------: | :----------------------------------------------------------: | :------------------------: | :--------------------------: |
| **B+Tree索引** |            最常见的索引类型，基于B+树数据结构实现            | InnoDB、MyISAM等大多数引擎 | 适合范围查询、排序等常见操作 |
|  **Hash索引**  | 底层使用哈希表实现，只有精确匹配索引列的查询才有效，不支持范围查询 |        Memory引擎等        |       等值查询，不常用       |
| **R-tree索引** |      MyISAM引擎的特殊索引类型，主要用于地理空间数据类型      |           MyISAM           |         地理空间数据         |
|  **全文索引**  | 通过建立倒排索引实现快速文本匹配，类似于Lucene、Solr、ES的搜索原理 |    InnoDB(5.6+)、MyISAM    |         文本内容搜索         |



**为什么要使用索引?**

举个例子

```sql
select * from teacher where tname = '马鸿运';
```

当它查找到 `马鸿运` 后 还会继续向后查找 tname为 '马鸿运' 的数据

![image-20250712134140160](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507121341286.png)

**索引优点：**

1. 通过创建唯一性索引，可以保证数据库表中的每一行数据的唯一性；
2. 可以加快数据的检索速度；
3. 可以加速表与表之间的连接；
4. 在使用分组和排序进行检索的时候，可以减少查询中分组和排序的时间

**索引缺点**

1. 创建索引和维护索引要耗费时间，这种时间随着数据量的增加而增加；
2. 索引需要占用物理空间，数据量越大，占用空间越大；
3. 会降低表的增删改的效率，因为每次增删改索引都需要进行动态维护；

**什么时候需要创建索引**

1. 频繁作为查询条件的字段应该创建索引；
2. 查询中排序的字段创建索引将大大提高排序的速度（索引就是排序加快速查找）；
3. 查询中统计或者分组的字段；

**什么时候不需要创建索引**

1. 频繁更新的字段不适合创建索引，因为每次更新不单单是更新记录，还会更新索引，保存索引文件；
2. where条件里用不到的字段，不创建索引；
3. 表记录太少，不需要创建索引；
4. 经常增删改的表；
5. 数据重复且分布平均的字段，因此为经常查询的和经常排序的字段建立索引。注意某些数据包含大量重复数据，因此他建立索引就没有太大的效果，例如性别字段，只有男女，不适合建立索引；



## 为什么InnoDB使用 B+ tree?

相比于 红黑树 二叉树 等数据结构 , b树每个节点能存放多个子节点,减少层数 .节点大小通常设置为磁盘块大小 ,更适合磁盘存储

而相比于 b 数而言 ,b+树 对于mysql更加高效:

每个非叶子节点 都用page 保存,固定大小为16K , 非叶子节点不保存数据的话 可以保存到更多的 键 ,提高阶数,减少层数 ,搜索效率高

b tree 无论是叶子节点还是非叶子节点,都会保存数据 ,导致每个page 存储的key减少 , pointer也会减少 , 大量数据的情况下 , 层数会更多 ,效率降低



![image-20250712143817130](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507121438199.png)





## 索引的分类

|   分类   |                含义                 |            特点             |  关键字  |
| :------: | :---------------------------------: | :-------------------------: | :------: |
| 主键索引 |        对表中主键创建的索引         | 默认自动创建,每个表只有一个 | primary  |
| 唯一索引 |    避免同一个表中某列中数据重复     |          可以多个           |  unique  |
| 普通索引 |          快速定位特定数据           |          可以多个           |          |
| 全文索引 | 查找文本中的关键词,不比较索引中的值 |          可以多个           | fulltext |



InnoDB 中 索引可以分为两类

|   分类   |                           含义                            |        特点         |
| :------: | :-------------------------------------------------------: | :-----------------: |
| 聚集索引 |  将数据存储和索引放到一起,索引结构的叶子节点保存了行数据  | 必须有,而且只有一个 |
| 二级索引 | 将数据和索引分开存储,索引结构的叶子节点关联的是对应的主键 |    可以存在多个     |

聚集索引的选取规则:

- 如果存在主键 , 主键索引就是聚集索引
- 如果不存在主键 , 将使用第一个 唯一性索引(unique)作为聚集索引
- 如果表没有主键 , 也没有合适的唯一索引 , 则innodb 会自动生成一个rowid作为隐藏的聚集索引

在InnoDB中,要做到查询

```sql
select * from teacher where tname = '薄青';
```

假设 给tname 创建了一个索引 , 首先会在tname字段的 索引中 查找键为'薄青' 对应的值 ,也就是 id ,然后根据 id主键 进行聚集索引查询 查询到 id = 008 的对应的值 `row` 整行的数据. 这种查询方式叫 <mark>回表查询</mark>



## 使用索引(基本语法)

**查看索引**

```sql
show index from teacher\G;
-- \G 是用来纵向展示的
```

**创建索引**

```sql
-- 因为teacher表的 id 被绑定了students表外键,新建一个teachers表
-- 创建 teachers 表
CREATE TABLE teachers (
    id VARCHAR(3) NOT NULL,
    tname VARCHAR(20) NOT NULL,
    age INT NOT NULL,
    object VARCHAR(10) NOT NULL,
    salary INT NOT NULL,
    email VARCHAR(50),
    PRIMARY KEY (id)
);

-- 插入数据
INSERT INTO teachers (id, tname, age, object, salary, email) VALUES
('001', '林飘飘', 33, '语文', 5000, 'linpiaopiao@school.com'),
('002', '李空', 22, '数学', 5000, 'likong@school.com'),
('003', '迪迦', 22, '政治', 5000, 'dijia@school.com'),
('004', '孙笑川', 30, '语文', 5000, 'sunxiaochuan@school.com'),
('005', '王一博', 28, '体育', 5000, 'wangyibo@school.com'),
('006', '张一鸣', 22, '数学', 5000, 'zhangyiming@school.com'),
('007', '西门吹雪', 16, '英语', 3000, 'ximenchuixue@school.com'),
('008', '薄青', 39, '英语', 8000, 'boqing@school.com'),
('009', '马鸿运', 80, '数学', 8000, 'mahongyun@school.com'),
('010', '龙公', 100, '体育', 8000, 'longgong@school.com'),
('011', '古月方源', 50, '英语', 8000, 'guyuefangyuan@school.com');

-- 或者
-- 这样会连着索引一起复制

create table teachers like teacher;
insert into teachers select *  from teacher;

-- 下面的例子不复制索引
create table teachers as select *  from teacher;
```

普通索引

```sql
create  index name_index on teachers (tname  );
alter table teachers add index name_index (tname);
```

唯一索引

```sql
create unique index name_index on teachers(tname);
create unique index email_index on teachers(email);
alter table teachers add unique index name_index (tname);
```

主键索引

```sql
alter table teachers drop primary key;
alter table teachers add primary key (email);
```

```sql
create unique index email_index on teachers(email);
alter table teachers add unique index email_index2 (email);
alter table teachers add unique index email_index3 (email);
```

**删除索引**

```sql
drop index email_index1 on teachers;
alter table teachers drop index email_index;
```



主键索引 就是 主键约束 , 语法 按照主键约束 只能使用alter ,其他的可以使用后create 和alter

**喜欢文章请点赞收藏评论 , 博主每日更新**