# select基本查询

select语句从数据库中返回查询的信息.

下面是一个例子

```sql
select * from students;
```

![image-20250709183658351](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/image-20250709183658351.png)

**select  语句的格式**

`select {* | [column , ...]}  [from from_item[,...]];`

- select 列表: 指定查询表中列名,可以是部分列或者是全部.
- from子句: 为select 声明一个或多个表源,
  - 表名或视图名, shema.table
  - 子查询 
  - alias 别名
  - join_type

| 语句                  | 对应句意         |
|:-------------------:|:------------:|
| select              | 一个或多个字段的列表   |
| */column            | 所有列/某列       |
| distinct            | 禁止重复         |
| column   expression | 选择指定字段   表达式 |
| alias               | 为表中的列提供临时名称  |
| from table          | 包含指定表        |

## select 查询指定列

```sql
select id , name from students;
```

![image-20250710001240682](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/202507100012728.png)

**使用算术运算符**

```sql
select id ,name ,score_rank * 10 from students;
```

![image-20250710001802045](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/202507100018098.png)

## SQL函数查询

SQL 拥有很多可用于计数和计算的内建函数

可以实现以下目的:

- 计算字段(计算总和(sum),平均值(avg),百分比())
- 数据加工(改大小写(upper), 截取文字(substring) ,拼接文字(concat))
- 日期处理(Now()返回现在时间 , datediff(str , Now()) 还剩多少天)
- 条件判断( if() ,case when 句)
- 处理空值( coalesce(null , str))
- 随机数( rand() )



<mark> SQL 函数就像 计算器 + 日历 + 文本bian'ji</mark>

语法是:

```sql
select function (column) from table_name;
```

**函数的基本类型**

- 字符串函数

- 数值函数

- 日期和时间函数

- 聚合函数

- 条件函数

- 窗口函数

- 自定义函数

  

   **字符串函数**

  ```sql
  -- 连接字符串
  SELECT CONCAT('Hello', ' ', 'World'); -- Hello World
  
  -- 转换为大写/小写
  SELECT UPPER('mysql'); -- MYSQL
  SELECT LOWER('MySQL'); -- mysql
  
  -- 字符串长度
  SELECT LENGTH('数据库'); -- 返回字节数
  SELECT CHAR_LENGTH('数据库'); -- 返回字符数
  
  -- 截取字符串
  SELECT SUBSTRING('MySQL', 2, 3); -- ySQ   SUBSTRING(str, pos, len)  SUBSTRING(str FROM pos FOR len)
  
  SELECT LEFT('MySQL', 2); -- My
  SELECT RIGHT('MySQL', 3); -- SQL
  
  -- 去除空格
  SELECT TRIM('  MySQL  '); -- MySQL
  SELECT LTRIM('  MySQL'); -- MySQL
  SELECT RTRIM('MySQL  '); -- MySQL
  ```

  可嵌套使用看函数的作用效果,如

  ![image-20250710114748226](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/202507101147323.png)

  **数值函数**

```sql
-- 四舍五入
SELECT ROUND(3.1415, 2); -- 3.14

-- 向上/向下取整
SELECT CEIL(3.2); -- 4
SELECT FLOOR(3.9); -- 3

-- 绝对值
SELECT ABS(-10); -- 10

-- 随机数
SELECT RAND(); -- 0-1之间的随机数

-- 幂运算
SELECT POWER(2, 3); -- 8
-- 符号函数
SELECT SIGN(-5);  -- 负数返回-1 → -1
SELECT SIGN(0);   -- 零返回0 → 0
SELECT SIGN(5);   -- 正数返回1 → 1
-- 幂运算
SELECT POWER(2, 3);   -- 2的3次方 → 8
SELECT SQRT(16);      -- 平方根 → 4
SELECT EXP(1);        -- e的1次方 → 2.718281828459045

-- 对数函数
SELECT LN(10);        -- 自然对数 → 2.302585092994046
SELECT LOG(2, 8);     -- 以2为底8的对数 → 3
SELECT LOG10(100);    -- 以10为底的对数 → 2

-- 随机数
SELECT RAND();        -- 0到1之间的随机数
SELECT RAND(123);     -- 带种子的随机数

-- 进制转换
SELECT BIN(10);       -- 十进制转二进制 → '1010'
SELECT OCT(10);       -- 十进制转八进制 → '12'
SELECT HEX(255);      -- 十进制转十六进制 → 'FF'
SELECT CONV('A',16,10); -- 十六进制A转十进制 → '10'

-- 位运算
SELECT BIT_COUNT(5);    -- 二进制中1的个数 → 2 (0101)
SELECT 5 & 3;           -- 位与 → 1 (0101 & 0011 = 0001)
SELECT 5 | 3;           -- 位或 → 7 (0101 | 0011 = 0111)
SELECT 5 ^ 3;           -- 位异或 → 6 (0101 ^ 0011 = 0110)
SELECT ~1;              -- 位取反 → 18446744073709551614 (64位系统)

-- 角度弧度转换
SELECT RADIANS(180);    -- 度转弧度 → 3.141592653589793
SELECT DEGREES(PI());   -- 弧度转度 → 180

-- 其他数学函数
SELECT PI();            -- 圆周率 → 3.141593
SELECT CRC32('MySQL');  -- 循环冗余校验 → 3259397556
```

​	**日期和时间函数**

```sql
-- 当前日期和时间
SELECT NOW(); -- 2023-05-15 14:30:45
SELECT CURDATE(); -- 2023-05-15
SELECT CURTIME(); -- 14:30:45

-- 提取日期部分
SELECT YEAR(NOW()); -- 2023
SELECT MONTH(NOW()); -- 5
SELECT DAY(NOW()); -- 15

-- 日期加减 
SELECT DATE_ADD(NOW(), INTERVAL 7 DAY); -- 7天后  函数名后不可以跟空格
SELECT DATE_SUB(NOW(), INTERVAL 1 MONTH); -- 1个月前 

-- 日期差
SELECT DATEDIFF('2023-12-31', NOW()); -- 剩余天数
```

**聚合函数**

```sql
-- 计数
SELECT COUNT(*) FROM students;

-- 求和
SELECT SUM(salary) FROM employees;

-- 平均值
SELECT AVG(score) FROM exams;

-- 最大值/最小值
SELECT MAX(price) FROM products;
SELECT MIN(age) FROM customers;
```

**条件函数**

```sql
-- IF函数(标记)
SELECT IF(score >= 60, '及格', '不及格') FROM students;

-- CASE WHEN
SELECT 
    name,
    CASE 
        WHEN score >= 90 THEN '优秀'
        WHEN score >= 70 THEN '良好'
        WHEN score >= 60 THEN '及格'
        ELSE '不及格'
    END AS grade
FROM students;

-- NULL处理
SELECT COALESCE(NULL, '默认值'); -- 返回第一个非NULL值
SELECT IFNULL(NULL, '替代值'); -- 如果为NULL则返回替代值
```

**窗口函数**(MySQL 8 以上)

```sql
-- 行号
SELECT name, score, ROW_NUMBER() OVER (ORDER BY score DESC) AS rank FROM students;

-- 分组排名
SELECT 
    department, 
    name, 
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank
FROM employees;

-- 累计求和
SELECT 
    date, 
    revenue,
    SUM(revenue) OVER (ORDER BY date) AS running_total 
FROM sales;
```

**自定义函数**

```sql
-- 创建自定义函数
DELIMITER //
CREATE FUNCTION calculate_tax(salary DECIMAL(10,2)) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE tax DECIMAL(10,2);
    IF salary > 10000 THEN
        SET tax = salary * 0.2;
    ELSE
        SET tax = salary * 0.1;
    END IF;
    RETURN tax;
END //
DELIMITER ;

-- 使用自定义函数
SELECT name, salary, calculate_tax(salary) AS tax FROM employees;
```



# 多表查询

多表查询要用到离散数学的概念: <mark>笛卡尔乘积</mark>

**笛卡尔乘积**

> 笛卡尔积是指在数学中，两个集合X和Y的笛卡尓积（Cartesian product），又称直积，表示为X × Y，第一个对象是X的成员而第二个对象是Y的所有可能有序对的其中一个成员

假设集合A={a, b}，集合B={0, 1, 2}，则两个集合的笛卡尔积为{(a, 0), (a, 1), (a, 2), (b, 0), (b, 1), (b, 2)}

当一个连接条件无效或者被遗漏时,其结果时一个笛卡尔乘积其中所有行的组合都被显示。<mark>在多表查询,需要消除无效的笛卡尔乘积</mark>

在 WHERE 子句中始终包含一个[有效的](https://so.csdn.net/so/search?q=有效的&spm=1001.2101.3001.7020)连接条件，除非你有特殊的需求，需要从所有表中组合所有的行。

例如

```sql
select name ,tname from students , teacher;
```

![image-20250710130422024](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/202507101304149.png)

解决:

```sql
select name ,tname from students ,teacher where students.teacherid = teacher.id;
```

![image-20250710131314135](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/202507101313607.png)

**标准分类**

- sql92标准 内连接
- sql99标准 内外连接,交叉连接

**查询分类**

- 连接查询
  - 内连接,相当于查询 a,b交集部分数据
  - 外连接:
    - 左外连接: 查询左边表的所有数据,以及两张表交集部分数据
    - 右外连接: 查询右边表的所有数据,以及两张表交集部分数据
  - 自连接: 当前表与自身的连接查询,自连接必须使用表别名
- 子查询

## 内连接

如上图中的 <mark>students.teacherid = teacher.id;</mark>

`select name ,tname from students ,teacher where students.teacherid = teacher.id;` 是<mark> 隐式内连接</mark>

**内连接特点**

1. 多表连接的结果为多表的交集部分；
2. n表连接，至少需要n-1个连接条件；
3. 多表不分主次，没有顺序要求；
4. <mark>一般为表起别名，提高阅读性和性能；</mark>
5. 可以搭配排序、分组、筛选….等子句使用；

>   起别名
>
> ```sql
> select name ,tname from students s ,teacher t where s.teacherid = t.id;
> ```

**显式内连接**

```sql
select name ,tname from students s inner join teacher t on s.teacherid = t.id;
```

显式地使用了 [inner] join on![image-20250710173359210](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/202507101733500.png)





## 外连接

**左外连接**

左右连接有何区别 ? 我们来举个例子

```sql
insert into students values(010,'窦唯' , 10,null);
```

我们插入了一个teacherid为null空值的数据,这时我们

```sql
select s.* ,t.tname ,t.age from students  s left outer join teacher t on t.id= s.teacherid; 
```



![image-20250710174143546](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/202507101741804.png)

这时候,在连接条件 ` t.id= s.teacherid`的条件下, name '窦唯' 这条数据被保留下来了

这时候我们如果使用右外连接 ,

```sql
select s.* ,t.tname ,t.age from students  s right outer join teacher t on t.id= s.teacherid; 
```

现在,右表中没有 teacherid 对应的 数据被保留下来了, 对应的左表中每个字段数据被设置为null 

![image-20250710174351866](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/202507101743197.png)





## 左右外连接核心区别

| 特性               | 左外连接 (LEFT JOIN)     | 右外连接 (RIGHT JOIN)    |
| :----------------- | :----------------------- | :----------------------- |
| **基准表**         | 左表(FROM子句中指定的表) | 右表(JOIN子句中指定的表) |
| **保留数据原则**   | 保留左表所有记录         | 保留右表所有记录         |
| **不匹配时的处理** | 右表字段显示为NULL       | 左表字段显示为NULL       |
| **使用频率**       | 非常常用                 | 相对较少                 |



## 自连接

自连接语法

```sql
select 字段列表 from 表a 别名a join 表a 别名b on 条件;
```

<mark> 自连接查询可以是 内连接查询,也能是外连接查询</mark>



students 表需要添加 'teamleader'字段

```sql
alter table students add column teamleader varchar(10) ; 
```

添加数据

```sql
update students set teamleader='张三' where id between 1 and 4;
update students set teamleader='基尼太美' where id between 5 and 8;
update students set teamleader='李宁' where id between 9 and 10;
```



**自查询** 组员和他的领导

```sql
select a.name '组员' ,b.name '组长' from students a ,students b where a.teamleader=b.name order by a.id; 
```

![image-20250710180318949](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/202507101803239.png)



## 联合查询

我们先为teacher表添加字段 'salary';

```sql
alter table teacher add column salary int;
```

更新数据

```sql
update teacher set salary = 5000 where age between 20 and 35 ;
update teacher set salary = 8000  where age > 35 ;
update teacher set salary = 3000  where age < 20 ;
```



这时候我们查询 `工资 大于 3000 并且 年龄小于 40 岁的老师`

```sql
select * from teacher  where salary > 3000 
union  all
select * from teacher where age <40;
```


![image-20250710181309040](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/202507101813284.png)



```sql
select * from teacher  where salary > 3000 
union  
select tname from teacher where age <40;
```

![image-20250710181420036](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/202507101814241.png)





对比上述两个例子,可以发现;

- union all 直接将查询结构合并
- union 查询结果去重



### 联合查询注意事项

```sql
select 字段列表 from tableA
union
select 字段列表 from tableB  ; 
```

<mark>union上下句子的字段列表一定要一致,字段类型一定要一致</mark>   否则 会报错

![image-20250710181944386](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/202507101819458.png)





如果喜欢文章,请点赞收藏 关注,我会持续更新

文章资料来源:

[bilibili mysql](https://www.bilibili.com/video/BV1Kr4y1i7ru/?spm_id_from=333.337.search-card.all.click&vd_source=92bcabed0867a8bc6b326550847c1d4a)

[csdn](https://guojiaqi.blog.csdn.net/article/details/134166829)
