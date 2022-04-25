

### jvm主要功能
    1. 通过ClassLoader寻找和装载class文件
    2. 解释字节码成为指令并执行，提供class文件的运行环境
    3. 进行运行期间的内存分配和垃圾回收
    4. 提供与硬件交互的平台

---

### class文件格式
	1. class文件是一组以8字节为单位的字节流，各个数据项目按照顺序紧凑排列
	2. 对于占用空间大于8字节的数据项，按照高位在前的方式分割成多个8字节进行存储
	3. Class文件格式里面只有两种类型: 无符号数，表
		a. 无符号数: 基本数据类型，以u1,u2,u4,u8(8个字节)来代表几个字节的无符号数
		b. 表: 由多个无符号数和其他表构成的复合数据类型，通常以_info结尾


|类型|名称|数量|描述|
|:----:|:----:|:----:|:----:|
|u4(4个字节)|magic|1|魔数(jdk8默认为CAFEBABE)|
|u2(2个字节)|minor_version|1|次版本号|
|u2|major_version|1|主版本号(jdk默认00 39，由于16进制表示，3*16+9=57)|
|u2	|constant_pool_count	|1|常量个数|
|cp_info	|constant_pool|	constant_pool_count - 1|具体常量|
|u2	|access_flags	|1	|访问标志|
|u2	|this_class	|1|	类索引|
|u2	|super_class	|1	|父类索引|
|u2|	interfaces_count|	1	|接口索引|
|u2|	interfaces|	interfaces_count|	具体接口|
|u2	|fields_count	|1	|字段个数|
|field_info	|fields	fields_count|	具体字段||
|u2	|methods_count	|1|	方法个数|
|method_info|	methods|	methods_count|	具体方法|
|u2|	attributes_count	|1	|属性个数|
|attribute_info	|attributes	|attributes_count|	具体属性|

---
	#### 常量池 constant_pool对应cp_info
		常量池其实有两个内容，一个是constant_pool_count，代表常量的个数，还有就是constant_pool ,代表常量的内容。例如 00 27 0a 00 07 00 18 ，00 27两位，第一位是tag，第二位是具体的内容，27换算成二进制 是 39，所以该类的常量池中有39个常量。紧接着就对应着 常量池的内容，首先看 0a ,是一个常量池的tag ， 对应10 ，其常量类型是constant_methodref , 找到对应的结构，如下 
			CONSTANT_Methodref_info {
				u1 tag; // 对应着上面的10
				u2 class_index; // 对应常量表的有效索引，此机构表示一个类或接口，当前字段或方法是这个类或接口的成员
				u2 name_and_type_index; // 必须是对常量池表的有效索引，表示当前字段或方法的名字和描述符
			}
			L表示对象,[表示数组，v表示void
	 descriptor: ([Ljava/lang/String;)V  代表 传入的是一个对象(L)数组([),并且方法返回值为void(V)
	 ```java
	 // 改内容为main方法 通过javap解析后的内容
	   public static void main(java.lang.String[]);
            descriptor: ([Ljava/lang/String;)V //代表方法参数
            flags: ACC_PUBLIC, ACC_STATIC
            Code: //代表方法的code内容
              stack=2, locals=1, args_size=1  // stack 方法执行时，栈的深度 ， locals 局部变量所需的存储空间，单位是slot(slot是虚拟机为局部变量分配内存所使用的最小单位)
                 0: getstatic     #2                  // Field java/lang/System.out:Ljava/io/PrintStream;
                 3: getstatic     #3                  // Field test:Ljava/lang/String;
                 6: invokevirtual #4                  // Method java/io/PrintStream.println:(Ljava/lang/String;)V
                 9: return
              LineNumberTable:
                line 26: 0
                line 27: 9
              LocalVariableTable:
                Start  Length  Slot  Name   Signature
                    0      10     0  args   [Ljava/lang/String;

	 ```

### 栈帧知识点

```java
    
    public int add(int a , int b) {
        int c = a + b;
        return a + b + c;
    }

```
    问该方法中存在几个变量
    该方法中存在4个变量。 第0位的this，之后分别是 a,b,c ,  按照顺序
    因为  该方法是实例方法，虚拟机栈帧的规定，如果是实例方法，则本地变量表的第0位存放的是this 的指针。
    但如果是static变量，就会没有this指针这一列
    下面是该方法的 class文件的 反编译内容
```java

 public int add(int, int);
    descriptor: (II)I
    flags: ACC_PUBLIC
    Code:
      stack=2, locals=4, args_size=3
         0: iload_1
         1: iload_2
         2: iadd
         3: istore_3
         4: iload_1
         5: iload_2
         6: iadd
         7: iload_3
         8: iadd
         9: ireturn
      LineNumberTable:
        line 10: 0
        line 11: 4
         // 方法的局部变量表 ，如果是实例变量，就会存在this
      LocalVariableTable:
        Start  Length  Slot  Name   Signature
            0      10     0  this   Lcoding/Add;
            0      10     1     a   I
            0      10     2     b   I
            4       6     3     c   I


```

#### point1 : slot是复用的，以节省栈帧的空间，这种设计可能会影响到系统的垃圾收集。所以不用的变量最好是显示的设置为null，以提高程序的性能
    ```java
        {
            byte[] bs = new byte[2 * 1024 * 1024];
        }
        int a = 2;
        // 先定义了 bs 的数组，会先分配一个slot ，然后在定义一个2，会占用bs的slot，不会重新进行分配
    ```

### 操作数栈  
    字节码的命令按顺序执行，每执行一条命令，都会将命令对应的结果压入到栈顶，如果方法有返回值，则返回栈顶 的数据

### 跨代引用
    一个代中的对象引用另一个代中的对象
    跨代引用假说: 跨代引用相对于同代引用来说只是极少数
    隐含推论: 存在互相引用关系的两个对象，是应该倾向于同时生存或同时消亡的
    问题: gc回收的时候，扫描完新生代后，还需要扫描老年代的内容

### 记忆集
    一种用于记录从非收集区域指向收集区域的指针集合的抽象数据结构。建立一个全局的数据结构，另外开辟一块内存来记录跨代引用的情况
    字长精度: 每个记录精确到一个机器字长，该字段包含跨代指针 

### 写屏障
    写屏障可以看成是jvm对 "引用类型赋值" 这个动作的 AOP。赋值的前后，可以额外干一些事情，(维护卡表的状态)
    通过写屏障来实现当对象状态改变后，维护卡表状态


### 三色标记
    


