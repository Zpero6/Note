## Z 字形变换

每行分为直上斜下两个阶段 ， 第0行和第num-1行只有 直上阶段

直上：已过周期基数+r （k>=0）

斜上：已过周期基数+正在过周期基数 - r (k>=1)

```java
if (numRows == 1)
            return s;
        int term = (numRows - 1) * 2;
```

```java
StringBuilder sd = new StringBuilder();
        for (int r = 0; r < numRows; r++) {
            for (int k = 0;; k++) {
                // 直下阶段
                int index = k * term + r;
                if (index >= s.length())
                    break;
                sd.append(s.charAt(index));
```

```JAVA
			 // 斜上阶段
                if (0 < r && r < numRows - 1) {
                    int index_lean = k * term + (term - r);
                    if (index_lean >= s.length())
                        break;
                    sd.append(s.charAt(index_lean));
                }
            }
		}
```

