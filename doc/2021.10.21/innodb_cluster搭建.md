### innodb_cluster集群搭建
>
> innodb_cluster是mysql官方提供的一种集群方式。其中使用mysql+MGR(mysql group replication)作为数据存储、数据复制，使用mysql shell对集群进行管理，使用mysql router进行服务负载均衡、故障转移等功能
> 安装参考以下链接:
> https://yonglun.me/mysql-8-0-innodb-cluster-manual/
> https://blog.csdn.net/qq540061627/article/details/81779106
> https://segmentfault.com/a/1190000011970688
> https://www.cnblogs.com/xinzhizhu/p/12346237.html
>

---

#### 相关准备
* 本次安装使用mysql 8.0.26 版本，从官网下载 **mysql-8.0.26-1.el7.x86_64.rpm-bundle.tar，mysql-router-community-8.0.26-1.el7.x86_64.rpm，mysql-shell-8.0.26-1.el7.x86_64.rpm**,以及二进制安装文件**mysql-8.0.26-linux-glibc2.12-x86_64.tar.xz**

---
* 下表为本次安装的机器
  |服务器名称|IP地址|网卡IP地址|操作系统|配置|安装内容|
  |:----:|:----:|:----:|:----:|:----:|:----:|
  |node2|10.120.68.168|10.121.3.220|CentOS Linux release 7.5.1804|8cpu,32G,1T|mysql,mysql-shell|
  |node1|10.120.64.79|10.121.2.4|CentOS Linux release 7.5.1804|8cpu,32G,1T|mysql,mysql-shell,mysql-router|
  |node3|10.120.130.89|10.120.130.89|CentOS Linux release 7.6.1810|8cpu,16G,1T|mysql,mysql-shell|
  > 查看操作系统的命令 cat /etc/centos-release
  > 查看cpu核数的命令 cat /proc/cpuinfo
---
* 其他准备
  1. 保证三台机器网络良好、最好在同一个网段中、宽带要足够
  2. 保证三台机器 / 目录下空间足够。本次搭建由于node1机器 / 目录下空间不足，无法使用rpm安装mysql，改用二进制文件安装mysql
  3. 保证三台机器端口可互相连通。本次搭建中node3的33061相关端口无法连通其他端口，导致最终node3服务器无法完全部署，导致本地最终只有两个节点可用。
  4. 编辑三台机器的 /etc/hosts文件，在最后加上三台服务器的主机IP解析记录
```json
      10.120.64.79   node1
      10.120.68.168  node2
      10.120.130.89  node3
```

---

* 服务器设置
**注: 以下造作需要在集群每一个节点服务器上执行**
1.设置 SELinux 策略，在SELinux 下 允许myql 连接
    sudo setsebool -P mysql_connect_any 1
2.设置 防火墙策略允许myql 连接
    sudo  firewall-cmd --add-port=3306/tcp --permanent
    sudo  firewall-cmd --add-port=33061/tcp --permanent
    sudo  firewall-cmd --reload

---

#### 安装MySQL Server
**注: 以下造作需要在集群每一个节点服务器上执行**
1. 将所有rpm文件拷贝到服务器，解压mysql-8.0.26-1.el7.x86_64.rpm-bundle.tar文件

2. 安装mysql-cummunity-server,需要以下安装内容(root用户下安装的)
    **rpm -ivh mysql-community-common-8.0.26-1.el7.x86_64.rpm --nodeps --force
    rpm -ivh mysql-community-client-plugins-8.0.26-1.el7.x86_64.rpm --nodeps --force
    rpm -ivh mysql-community-libs-8.0.26-1.el7.x86_64.rpm --nodeps --force
    rpm -ivh mysql-community-client-8.0.26-1.el7.x86_64.rpm --nodeps --force
    rpm -ivh mysql-community-server-8.0.26-1.el7.x86_64.rpm --nodeps --force**
    注意: 安装mysql-community-server的时候一定要保证/ 目录下的空间足够
    
3. 初始化mysql-community-server
    mysqld --initialize;
    
4. 修改mysql目录的所有者
    chown mysql:mysql /var/lib/mysql -R
    
5. 启动mysql服务，并设置为自动启动
    启动mysql服务
    sudo systemctl start mysqld
    设置为自动启动
    sudo systemctl enable mysqld
    
6. 第三步初始化过程会为root用户生成随机初始密码，通过以下命令查看
    cat /var/log/mysqld.log | grep password
    
7. 更改root密码并配置权限相关命令
    mysql -uroot -p 输入随机密码
    -- 修改root@localhost的密码,xxxx替换为需要设置的密码
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY  'cnki@1234'; 
    -- 创建root@% 用户，并设置密码,xxxx替换为需要设置的密码
    create user 'root'@'%' identified with mysql_native_password by  'cnki@1234'; 
    -- 设置root@% 用户权限
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; 
    -- 使设置的权限信息立即失效
    flush privileges;
    -- 设置完成，退出
    quit;
    
---


#### 安装mysql-shell(所有节点)
rpm -ivh mysql-shell-8.0.25-1.el8.x86_64.rpm --nodeps --force

---

#### 安装mysql-shell(所有节点)
rpm -ivh mysql-shell-8.0.25-1.el8.x86_64.rpm --nodeps --force

---

#### 创建集群
* 配置和准备服务器节点(所有节点都执行该操作)
  1. 在node1节点执行下面命令:
      -- 使用mysql shell 登陆第一个服务器节点
      mysqlsh --uri root@ow-rhel-01:3306
  2. 输入root密码后，进入mysql shell接面，执行下面命令
      --配置服务器节点,对提示均输入y, 最后会重启该节点的MySQL 实例
      --显示 NOTE: MySQL server at xxxx was restarted. 则配置完成
      dba.configureLocalInstance();
      -- 检查服务器节点配置, 显示The instance  XXXX is valid to be used in an InnoDB cluster 表明配置正确，可以加入群集
      dba.checkInstanceConfiguration('root@ow-rhel-01:3306');
      --退出mysql shell
      \q
      
---

* 创建服务器集群(只在node1节点上执行)
  1. node1节点登陆mysql-shell
      -- 使用mysql shell 登陆第一个服务器节点
      mysqlsh --uri root@ow-rhel-01:3306
  2. 执行以下命令
``` shell
    # 下面命令创建名字为 'mainCluster' 的群集，设置为主-主模式，并将当前节点加入群集
    # InnoDB Cluster 有主-从模式，和主-主模式，本例子使用主-主模式，即每个节点均可以写入和查询
    # 命令执行后，出现Cluster successfully created 表明群集创建成功
    var cluster = dba.createCluster('mlampCluster')
    # 将第二个节点加入群集
    cluster.addInstance('root@node2:3306');
    # 将第三个节点加入群集
    cluster.addInstance('root@node3:3306');
    # 用下面命令显示群集状态
    cluster.status();
    # 创建一个mysql 用户，用于管理集群，这样不需每次使用root 进行管理
    cluster.setupAdminAccount('clusterAdmin’)
    # 创建一个mysql 用户，用于mysql router
    cluster.setupRouterAccount('mysqlrouter');
    # 退出mysql shell
    \q
```
    注意:此处可能产生以下几个问题:
    1. 由于集群采用 MGR 模式进行复制，所以先确保mysql服务中存在该plugin，或者直接添加
    install plugin group_replication soname 'group_replication.so';
    show plugins;
    2. 执行 cluster.addInstance的时候可能会出现下面问题:
    **  [ERROR] [MY-011735] [Repl] Plugin group_replication reported: '[GCS] There is no local IP address matching the one configured for the local node (db-1-1:33061).'**
      解决本次安装中该问题的方式是使用ifconfig命令查看网卡ip，本例中node1的网卡ip为10.121.2.4，然后，将以下内容写入到 /etc/my.cnf文件下
      loose-group_replication_local_address="10.121.2.4:33061"
      loose-group_replication_group_seeds="10.121.2.4:33061"
      report_host=10.121.2.4
      重新执行命令即可
  3. 以上步骤完成之后，就有了一个主从模式的集群，使用命令 cluster.switchToMultiPrimaryMode()即可切换成多主模式
  4. 三个节点的集群，均可以写入、均可以读取(全主模式下)，数据保持强一致，一个节点出现故障，集群仍可工作。故障节点恢复后，节点会自动同步数据，同步完成后，恢复的节点可提供服务

---

#### 初始化mysql router
使用下面命令初始化mysql router (当前只在node1节点安装 mysql router。也可以找一个找一个单独的节点部署mysql router)
-- 下面命令初始化mysqlrouter
-- user mysqlrouter 指定 mysqlrouter服务运行的linux用户，如修改为其它用户需要先创建
-- 初始化mysqlrouter的配置文件及脚本目录
sudo mysqlrouter --bootstrap root@node1:3306 --user=mysqlrouter --directory /var/lib/myrouter

-- 启动mysqlrouter服务 (但这个命令好像没有启动，目前使用另一个种方式启动)
sudo systemctl start mysqlrouter
-- 另一种启动方式
进入 /var/lib/myrouter目录，执行 其中的 start.sh,即可启动

-- 将mysqlrouter服务设置为自动启动
sudo systemctl enable mysqlrouter

---

#### 验证
使用mysql router登陆系统。
在安装mysqlrouter的服务器执行命令:
mysql -u root -P 6446 -h 10.120.64.79 -p **注意。端口是6446**
输入密码，即可进行相关的sql操作

springboot等连接的话，也是直接通过 6446端口即可，其他参数不变


