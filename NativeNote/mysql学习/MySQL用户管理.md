> 代码可全程复制 或 跟敲  



## 创建用户

```sql
create user 'ice'@'localhost' identified by '123456';

```

'@'后面的字符是登录的主机

<mark>在多人同时使用mysql时 , 通常要设置权限和用户主机</mark>

|   字段    |                     控制类型                      |
| :-------: | :-----------------------------------------------: |
|     %     |                 所有主机都可使用                  |
| localhost | 不会变成ip地址127.0.0.1 ,而是通过unixSocket连接的 |
| 127.0.0.1 |         通过tcp/ip协议连接,只能在本地访问         |
|    ::1    |          兼容ipv6,表示同ipv4的127.0.0.1           |

关于socket 请自行百度

```sql
create user 'ice'@'%' identified by '123456';
create user 'ice'@'127.0.0.1' identified by '123456';
```



## 查看用户列表

```sql
SELECT User, Host FROM mysql.user ;
```

![image-20250712110614301](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507121106439.png)

## 权限管理

```sql
-- 授予test数据库所有权限
grant ALL PRIVILEGES ON mssqldata.* TO 'ice'@'localhost';

-- 授予特定表只读权限
grant SELECT ON mssqldata.students TO 'ice'@'%';
grant SELECT ON mssqldata.teacher TO 'ice'@'%';
-- 授予多个权限
grant SELECT, INSERT, UPDATE ON mssqldata.*  TO 'ice'@'127.0.0.1';

-- 授予创建用户权限
GRANT CREATE USER ON *.* TO 'ice'@'localhost';

-- 授予所有权限(谨慎使用)
GRANT ALL PRIVILEGES ON *.* TO 'ice'@'localhost' WITH GRANT OPTION;

-- 刷新权限
FLUSH PRIVILEGES;

```

## 查看用户权限

```sql
show grants FOR 'ice'@'localhost';
show grants FOR 'ice'@'%';
show grants FOR 'ice'@'192.168.1.%';
```

## 修改账户属性

```sql
-- MySQL 5.7.6+版本
alter user 'ice'@'localhost' IDENTIFIED BY '12345';

-- 旧版本
SET PASSWORD FOR 'ice'@'localhost' = PASSWORD('12345');
-- 重命名
RENAME USER 'ice'@'localhost' TO 'snow'@'localhost';

-- 锁定账户
ALTER USER 'ice'@'localhost' ACCOUNT LOCK;
-- 解锁
ALTER USER 'ice'@'localhost' ACCOUNT UNLOCK;

-- 撤销部分权限
REVOKE INSERT ON test.* FROM 'ice'@'localhost';
-- 撤销所有权限
REVOKE ALL PRIVILEGES ON *.* FROM 'ice'@'localhost';


-- 删除用户
DROP USER 'ice'@'localhost';
```

