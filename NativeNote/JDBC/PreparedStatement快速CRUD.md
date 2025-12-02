## 什么是CRUD

CRUD 是 增删改查的英文首字母拼接 . 对应到 sql 里就是

`insert/create` 	`delete/drop`  	alter/update     `select/show`

## 为什么用PreparedStatement

1.  预编译SQL语句 , 语句固定可以复用
2. 参数化查询 , 依靠值传递 , 有效防止传入关键字或导致sql注入的问题

## 源码贴在这里

```java
package com.zpero.base;

import org.junit.Test;

import java.sql.*;
import java.util.Scanner;

public class JDBCOperation {
    @Test
    public void testQuerySingleRowAndCol() throws SQLException {
        //注册驱动
        //获取连接
        Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mssqldata",
                "root",
                "123456"
        );

        PreparedStatement ps =
                conn.prepareStatement("SELECT count(*) as Count FROM teacher");

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            System.out.println(rs.getInt("Count"));

        }
        rs.close();
        ps.close();
        conn.close();

    }
    @Test
    public void testQuerySingleRow() throws Exception {
        //注册驱动
        //获取连接
        Connection conn2 = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mssqldata",
                "root",
                "123456"
        );

        PreparedStatement ps2 =
                conn2.prepareStatement("SELECT * FROM teacher where id = ?");
        ps2.setInt(1, 10);
        ResultSet rs2 = ps2.executeQuery();
        while (rs2.next()) {
            int id = rs2.getInt("id");
            String formattedId = String.format("%03d", id);
            String tname = rs2.getString("tname");
            int age = rs2.getInt("age");
            String object = rs2.getString("object");
            int salary = rs2.getInt("salary");
            String email = rs2.getString("email");
            System.out.println(formattedId + '\t' + tname + '\t' + age + '\t' + object + '\t' + salary + '\t' + email);
        }
    }

    @Test
    public void testQueryMoreRow() throws SQLException {
        //注册驱动
        //获取连接
        Connection conn3 = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mssqldata",
                "root",
                "123456"
        );

        PreparedStatement ps3 =
                conn3.prepareStatement("SELECT * FROM teacher where age > ?");
        ps3.setInt(1, 25);
        ResultSet rs3 = ps3.executeQuery();
        while (rs3.next()) {
            int id = rs3.getInt("id");
            String formattedId = String.format("%03d", id);
            String tname = rs3.getString("tname");
            int age = rs3.getInt("age");
            String object = rs3.getString("object");
            int salary = rs3.getInt("salary");
            String email = rs3.getString("email");
            System.out.println(formattedId + '\t' + tname + '\t' + age + '\t' + object + '\t' + salary + '\t' + email);

        }
        rs3.close();
        ps3.close();
        conn3.close();

    }

    @Test
    public void testInsert () throws SQLException {
        Connection conn4 = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mssqldata",
                "root",
                "123456"
        );
        PreparedStatement ps4 =
                conn4.prepareStatement("INSERT INTO teacher(id,tname,age , object ,salary , email ) VALUES (?,?,?,?,?,?)");
        ps4.setInt(1,12);  ps4.setString(2,"曼波"); ps4.setInt(3,18);
        ps4.setString(4,"体育"); ps4.setInt(5,5000); ps4.setString(6,"manbo@school.com");

        int count = ps4.executeUpdate();

        if(count > 0){
            System.out.println("success");
        }else {
            System.out.println("failed");
        }
        ps4.close();
        conn4.close();
    }
    @Test
    public void testUpdate () throws Exception {

        Connection conn5 = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mssqldata",
                "root",
                "123456"
        );

        PreparedStatement ps5 = conn5.prepareStatement("update teacher set salary = ? where tname = ?");
        ps5.setInt(1,3000);
        ps5.setString(2,"曼波");
        int count = ps5.executeUpdate();
        if(count > 0){
            System.out.println("success");
        }else {
            System.out.println("failed");
        }
        ps5.close();
        conn5.close();


    }
    @Test
    public  void testDelete () throws Exception {
        Connection conn6 = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mssqldata",
                "root",
                "123456"
        );
        PreparedStatement ps6 = conn6.prepareStatement("delete from teacher where tname = ?");
        ps6.setString(1,"曼波");
        int count = ps6.executeUpdate();
        if(count > 0){
            System.out.println("success");
        }else {
            System.out.println("failed");
        }
        ps6.close();
        conn6.close();
    }


}

```

@Test是 Junit 参数化测试注解 ,因此要导入 JUnit jar包  [junit](https://repo1.maven.org/maven2/junit/junit/4.12/junit-4.12.jar)  hamcrest jar包 [hamcrest](https://mvnrepository.com/artifact/org.hamcrest/hamcrest/2.2)
点击jar 即可下载


同上一篇文章流程 导入lib文件库 [文章链接](https://juejin.cn/post/7526309936814014510)

添加class文件 JDBCOperation



## PreparedStatement查询

查询有多少条记录 

```java
@Test
    public void testQuerySingleRowAndCol() throws SQLException {
        //注册驱动
        //获取连接
        Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mssqldata",
                "root",
                "123456"
        );

        PreparedStatement ps =
                conn.prepareStatement("SELECT count(*) as Count FROM teacher");

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            System.out.println(rs.getInt("Count"));

        }
        rs.close();
        ps.close();
        conn.close();

    }
```

**注册驱动被集成到了 DriverManager中 具体代码见 上一篇文章 `注册驱动` 部分 , 具体思路就是 Drive 类 实现了 驱动接口 , 然后在静态代码块中实现了加载时自动注册**

 <mark>executeQuery() 方法返回的类型是 ResultSet 类型</mark>

**查询单行数据**

```java
 @Test
    public void testQuerySingleRow() throws Exception {
        //注册驱动
        //获取连接
        Connection conn2 = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mssqldata",
                "root",
                "123456"
        );

        PreparedStatement ps2 =
                conn2.prepareStatement("SELECT * FROM teacher where id = ?");
        ps2.setInt(1, 10);
        ResultSet rs2 = ps2.executeQuery();
        while (rs2.next()) {
            int id = rs2.getInt("id");
            String formattedId = String.format("%03d", id);
            String tname = rs2.getString("tname");
            int age = rs2.getInt("age");
            String object = rs2.getString("object");
            int salary = rs2.getInt("salary");
            String email = rs2.getString("email");
            System.out.println(formattedId + '\t' + tname + '\t' + age + '\t' + object + '\t' + salary + '\t' + email);
        }
    }
```

**查询多行数据**

```Java
 @Test
    public void testQueryMoreRow() throws SQLException {
        //注册驱动
        //获取连接
        Connection conn3 = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mssqldata",
                "root",
                "123456"
        );

        PreparedStatement ps3 =
                conn3.prepareStatement("SELECT * FROM teacher where age > ?");
        ps3.setInt(1, 25);
        ResultSet rs3 = ps3.executeQuery();
        while (rs3.next()) {
            int id = rs3.getInt("id");
            String formattedId = String.format("%03d", id);
            String tname = rs3.getString("tname");
            int age = rs3.getInt("age");
            String object = rs3.getString("object");
            int salary = rs3.getInt("salary");
            String email = rs3.getString("email");
            System.out.println(formattedId + '\t' + tname + '\t' + age + '\t' + object + '\t' + salary + '\t' + email);

        }
        rs3.close();
        ps3.close();
        conn3.close();

    }

```

## 增加新数据

```java
  @Test
    public void testInsert () throws SQLException {
        Connection conn4 = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mssqldata",
                "root",
                "123456"
        );
        PreparedStatement ps4 =
                conn4.prepareStatement("INSERT INTO teacher(id,tname,age , object ,salary , email ) VALUES (?,?,?,?,?,?)");
        ps4.setInt(1,12);  ps4.setString(2,"曼波"); ps4.setInt(3,18);
        ps4.setString(4,"体育"); ps4.setInt(5,5000); ps4.setString(6,"manbo@school.com");

        int count = ps4.executeUpdate();

        if(count > 0){
            System.out.println("success");
        }else {
            System.out.println("failed");
        }
        ps4.close();
        conn4.close();
    }
```

<mark>executeUpdate() 返回 int数据 , 受影响的行数</mark>

## 改

```Java
 @Test
    public void testUpdate () throws Exception {

        Connection conn5 = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mssqldata",
                "root",
                "123456"
        );

        PreparedStatement ps5 = conn5.prepareStatement("update teacher set salary = ? where tname = ?");
        ps5.setInt(1,3000);
        ps5.setString(2,"曼波");
        int count = ps5.executeUpdate();
        if(count > 0){
            System.out.println("success");
        }else {
            System.out.println("failed");
        }
        ps5.close();
        conn5.close();


    }
```

## 删

```java
 @Test
    public  void testDelete () throws Exception {
        Connection conn6 = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mssqldata",
                "root",
                "123456"
        );
        PreparedStatement ps6 = conn6.prepareStatement("delete from teacher where tname = ?");
        ps6.setString(1,"曼波");
        int count = ps6.executeUpdate();
        if(count > 0){
            System.out.println("success");
        }else {
            System.out.println("failed");
        }
        ps6.close();
        conn6.close();
    }
```

