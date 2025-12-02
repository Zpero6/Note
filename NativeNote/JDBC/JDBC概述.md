## 何为JDBC

JDBC (JAVA Datebase connectivity)就是使用java语言操作关系型数据库的一套API

JDBC 驱动程序可以做三件事:

- 与数据库建立联系
- 向数据源发送查询和更新语句
- 处理接结果

下面是一个官方文档的例子:

```java
Connection con = DriverManager.getConnection(

    					"jdbc:myDriver:wombat", "myLogin", "myPassword");
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT a, b, c FROM Table1");
    while (rs.next()) {
    	int x = rs.getInt("a");
    	String s = rs.getString("b");
    	float f = rs.getFloat("c");

	}
```



![intro.anc2](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507131115950.gif)

在两层模型中，Java 小程序或应用程序直接与数据源通信。这需要一个 JDBC  驱动程序，该驱动程序可以与正在访问的特定数据源进行通信。用户的命令将传递到数据库或其他数据源，并将这些语句的结果发送回用户。数据源可能位于用户通过网络连接的另一台计算机上。这称为客户端/服务器配置，其中用户的计算机作为客户端，包含数据源的计算机作为服务器。网络可以是 Intranet，例如，连接公司内部的员工，也可以是 Internet。

![intro.anc1](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507131114304.gif)

在三层模型中，命令被发送到服务的 “中间层” ，然后该服务将命令发送到数据源。数据源处理命令并将结果发送回中间层，然后中间层将其发送给用户。MIS  主管发现三层模型非常有吸引力，因为中间层可以保持对访问和可对公司数据进行的更新类型的控制。另一个优点是它简化了应用程序的部署。最后，在许多情况下，三层架构可以提供性能优势。



JDBC 定义了一套操作所有关系型数据库的接口 , 各个厂商去实现这套接口,提供相应的驱动jar包 , 所以 我们使用JDBC 操作数据库 , 其实是使用的是驱动 jar 包的类



因为所有厂商使用相同的接口 ,  一套java代码不需要针对不同的数据库进行开发 , 实现了 数据库接口的模块化





## API

创建一个java项目 , 命名为lib

![image-20250713125710398](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507131257492.png)

去mysql官网下载jar包

["点击进入下载页面"](https://downloads.mysql.com/archives/c-j/)

![image-20250713130207587](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507131302717.png)

进入下载位置,解压缩,复制jar包

![image-20250713130325259](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507131303309.png)

右键项目名 , 新建目录

![image-20250713125835645](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507131258709.png)

单击lib文件夹 , ctrl + v 粘贴jar包

![image-20250713130451401](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507131304464.png)

右键lib目录 选择添加为库

![image-20250713130539065](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507131305106.png)

在src文件夹新建包 `com.zpero.base`

测试代码如下;

```java
package com.zpero.base;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class JDBCQucik {
    public static void main(String[] args) throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/mssqldata";
        String usernaem = "root";
        String password = "123456";
        Connection conn = DriverManager.getConnection(url, usernaem, password);
        Statement st = conn.createStatement();
        String sql = "select *  from teacher ; ";
        ResultSet rs = st.executeQuery(sql);
        while (rs.next()) {
            int id = rs.getInt ("id");
            String name = rs.getString("tname");
            int age = rs.getInt("age");
            String object = rs.getString("object");
            int salary = rs.getInt("salary");
            String email = rs.getString("email");
            String formattedId = String.format("%03d", id);
            System.out.println(formattedId + '\t' + name + '\t' + age + '\t' + object + '\t' + salary + '\t' + email );
        }
        rs.close();
        st.close();
        conn.close();
    }
}

```

点击运行,注意更改url 和username , password ,换成自己的





###  **注册驱动**

```java
Class.forName("com.zpero.cj.jdbc.Driver");
```

- 这是java 6 之前的写法,手动加载JDBC驱动,让JVM 加载 `com.zpero.cj.jdbc.Driver` 类

- com.zpero.cj.jdbc.Driver类会自动向 `DriverManager`注册驱动,让DriverManager.getConnection() 找到正确的驱动

  - ![image-20250713163317030](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507131633159.png)

  - ```java
    static {
        try {
            java.sql.DriverManager.registerDriver(new Driver());
        } catch (SQLException E) {
            throw new RuntimeException("Can't register driver!");
        }
    }
    ```

    

- 在java中,当使用JDBC连接数据库时需要加载数据库特定的驱动程序,让jdbc api 能识别并交互特定的数据库

**connection**

- 用于建立与数据库之间的通信通道 , 只要connection不是空 , 则代表一次数据库连接
  - URL : jdbc:mysql://ip地址:端口号/数据库名称?参数键值对
- connection 接口还负责 管理事务 , 提供了 `commit` 和 `rollback` 方法
- 用于创建 `Statement`对象,保存sql语句
- connection使用后需要释放资源

**statement**

- `Statement`接口用于执行SQL语句并和数据库进行交互 . 他是JDBC API 的一个重要接口 . 通过Statement 可以向数据库发送SQL语句并执行

- SQL注入

  - ```java
    package com.zpero.base;
    
    import java.sql.*;
    import java.util.Scanner;
    
    public class JDBCQucik {
        public static void main(String[] args) throws Exception {
            DriverManager.registerDriver(new com.mysql.cj.jdbc.Driver());
            String url = "jdbc:mysql://localhost:3306/mssqldata";
            String usernaem = "root";
            String password = "123456";
            Connection conn = DriverManager.getConnection(url, usernaem, password);
    
            System.out.println("输入老师姓名: ");
            Scanner sc = new Scanner(System.in);
            String name = sc.nextLine();
            Statement st = conn.createStatement();
            String sql = "SELECT * FROM teacher where tname = '" + name + "'";  // 修复SQL注入漏洞并修正语法错误
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                int id = rs.getInt ("id");
                String tname = rs.getString("tname");
                int age = rs.getInt("age");
                String object = rs.getString("object");
                int salary = rs.getInt("salary");
                String email = rs.getString("email");
                String formattedId = String.format("%03d", id);
                System.out.println(formattedId + '\t' + tname + '\t' + age + '\t' + object + '\t' + salary + '\t' + email );
            }
            rs.close();
            st.close();
            conn.close();
        }
    }
    
    ```

    替换原来的代码 , 运行 ,输入 `xxx' or '1' ='1`

    会得到

    ![image-20250713173326191](https://cdn.jsdelivr.net/gh/icecreamstorm/Typora@master/img/202507131733275.png)

- 执行SQL语句会出现 SQL注入的问题

  - 输入 `-- `注释后边代码
  - 字符串拼接 `' or '1' ='1 ` 和后边的 `'` 拼接为 tname = '' or '1'='1' 永真式 , 把所有的数据全部暴漏

****

**PreparedStatement**

- `PreparedStatement` 是 `statement` 接口的子接口 ,用于预编译的SQL查询 
  - 在创建 PreparedStatemen时 就会预编译SQL语句 ,也就是说 SQL语句已经固定
  - 防止SQL注入 : PreparedStatement 支持参数化查询,将数据作为参数传递到SQL语句中 , 采用 ? 占位符 的方式 将传入的参数 用一对单括号 包裹起来 , 无论传递什么都作为值 . 有效防止传入关键字或值导入sql注入的问题
  - 性能提升 : PreparedStatement是预编译sql语句,用提sql语句多次执行可以复用 , 不用那个重新编译和解析

**ResultSet**

- 表示从数据库中 执行查询语句所返回的结构集 . 提供了用于遍历和访问查询结果的方式
- 可以使用 next() 方法 将游标移动到结果集的下一行,逐行遍历数据库查询的结果 , 返回值类型为 boolean , true 代表有下一行结果 , false 则代表没有
- 获取单行结果 , 可以通过getXxx的方式获取单列的某个数据 , 该方法为重载方法,支持索引和列名进行获取

