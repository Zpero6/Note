## Set 常见命令

1. Sadd key member 添加元素
2. srem key member 移除set中的指定元素
3. scard key 返回set元素个数
4. sismember key member 判断是不是在一个set中
5. smembers 获取所有元素
6. sinter key1 key2 求两个集合的交集
7. sdiff key1 key2 求两个集合的差集
8. sunion key1 key2 求两个集合的并集
9. 





## SpringDataRedis 的序列化

#### 1.使用@autoWare 自动装填 RedisTemplete

#### 2. 手动设置Redis的序列化(因为有用jdkSerializer把key和value都给一起序列化造成可读性差和内存浪费的wenti)

application的同级包中 , 新建一个 config包 , 创建 RedisConfig.java . 返回一个符合预期的RedisTemplete

```java
@Configuration
public class ReidsConfig {
    public RedisTemplate<String, Object> RedisTemplate(RedisConnectionFactory connectionFactory) {


        RedisTemplate<String, Object> template = new RedisTemplate<>();
        //设置连接工厂
        template.setConnectionFactory(connectionFactory);
        //创建Json序列化工具
        GenericJackson2JsonRedisSerializer jsonRedisSerializer = new GenericJackson2JsonRedisSerializer();
        // 设置key的序列化
        template.setKeySerializer(RedisSerializer.string());
        template.setHashKeySerializer(RedisSerializer.string());
        //设置value的序列化
        template.setValueSerializer(jsonRedisSerializer);
        template.setHashValueSerializer(jsonRedisSerializer);
        //return
    }
}
```

@Data：自动生成getter、setter、toString、equals和hashCode方法
@AllArgsConstructor：生成包含所有字段的构造函数
@NoArgsConstructor：生成无参构造函数

#### 3. java Object 转换成json 字符串会将 class 写入json , 造成资源浪费 , 手动序列化解决问题

```java
 <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
            <version>1.2.76</version>
        </dependency>
```

手动序列化和反序列化

```java
  @Test
    void testSaveUser() {
		//创建 user对象
        User user = new User("mike",20);
        //序列化
        String userJson = JSON.toJSONString(user);
        //写入数据 to "user:200"
        stringRedisTemplate.opsForValue().set("user:200" , userJson);
        //get data from user:200
        String value = stringRedisTemplate.opsForValue().get("user:200");
        //deserialization
        User jsonToUser = JSON.parseObject(userJson,User.class);
        System.out.println("user = " + jsonToUser);
    }
```

