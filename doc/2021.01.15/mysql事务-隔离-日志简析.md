## mysql事务、隔离级别、日志简析
---
> 参考网址 https://zhuanlan.zhihu.com/p/48327345
> **https://www.cnblogs.com/kismetv/p/10331633.html**  主要参考
> https://www.cnblogs.com/wyaokai/p/10921323.html
> **https://www.cnblogs.com/wy123/p/8365234.html**  主要参考
> https://zhuanlan.zhihu.com/p/35574452
> 及mysql官网 https://dev.mysql.com/doc/refman/8.0/en/innodb-undo-logs.html
> https://www.cnblogs.com/f-ck-need-u/p/9010872.html#auto_id_0
>
> https://zhuanlan.zhihu.com/p/161901853
---

- ### mysql事务
  > 事务(Transaction)是访问和更新数据库的程序执行单元；事务中可能包含一个或多个sql语句，这些语句要么都执行，要么都不执行
  > 
  > mysql中事务由每个具体的存储引擎实现。mysql三大存储引擎中，只有innodb支持事务，myisam和memory引擎不支持事务。
  > 
  > innodb引擎默认采用自动提交的方式提交事务，show variables like 'autocommit'可以看到value=on。可以使用 set autocommit=0 设置为手动提交，需要使用 start transaction; sql语句；commit来进行事务操作。但这种关闭是针对连接的，在一个连接中修改该值，不会影响其他连接的相关设置。
  
  
  - ACID特性: ACID是衡量事务得四个特性 
    - 原子性(Atomicty) : 是指一个事务是一个不可分割的工作单位，其中的操作要么都做，要么都不做；如果事务中一个sql语句执行失败，则已执行的语句也必须回滚，退回到事务之前的状态。
    
    > #### 原子性的实现依靠 undo log（回滚日志）实现

    - 一致性(Consistency) : 是指事务执行结束后，数据库的完整性约束没有被破坏，事务执行的前后都是合法的数据状态。
      
    > 数据库的完整性约束包括但不限于:实体完整性(行的主键存在且唯一)、列完整性(字段的类型、大小、长度要符合要求)、外键约束、用户自定义完整性(如转账前后，两个账户余额的和应该不变)等
    
    - 隔离性(Isolation) : 是指事务内部的操作与其他事务是隔离的，并发执行的各个事务之间不能互相干扰。

    > 锁是隔离性的主要条件，但也会存在并发情况数据的问题。undo log可以实现MVCC多版本控制
    
    - 持久性(Durability) : 是指事务一旦提交，他对数据库的改变就应该是永久性的。接下来的其他操作或故障不应该对其有任何影响。

    > #### 持久性的实现依靠 redo log（重做日志）实现
  
  ---
  
  - ### undo log(回滚日志)
    undo log属于逻辑日志，记录的是sql执行相关的信息。当发生回滚时，InnoDB会根据undo log的内容做与之相反的工作；对于每个insert，回滚时会执行delete；对于每个detele，回滚时会执行insert；对于每个update，回滚时会执行一个相反的update，把数据改回去。
    以update操作为例:当事务执行update时，其生成的undo log中会包含被修改行的主键(以便知道修改了哪些行)、修改了哪些列、这些列在修改前后的值等信息，回滚时便可以使用这些信息将数据还原到update之前的状态
    当事务开始之前，就会将当前的版本生成undo log，undo也会产生redo来保证undo log的可靠性。
    当事务提交之后，undo log并不能立马被删除，而是放入待清理的链表，由purge线程判断是否有其他事务在使用undo段中表的上一个事务之前的版本信息，决定是否可以清理undo log的空间。
    
    > 使用undo log时事务执行顺序
    >
    >1. 记录START T 
    >2. 记录需要修改的记录的旧值（要求持久化）
    >3. 根据事务的需要更新数据库（要求持久化）
    >4. 记录COMMIT T 
    >
    >使用undo log进行宕机回滚
    >1. 扫描日志，找出所有已经START,还没有COMMIT的事务。
    >2. 针对所有未COMMIT的日志，根据undo log来进行回滚。 
    >
    > 如果数据库访问很多，日志量也会很大，宕机恢复时，回滚的工作量也就很大，为了加快回滚，可以通过checkpoint机制来加速回滚,
    >1. 在日志中记录checkpoint_start (T1,T2…Tn) (Tx代表做checkpoint时，正在进行还未COMMIT的事务）
    >2. 等待所有正在进行的事务（T1~Tn）COMMIT
    >3. 在日志中记录checkpoint_end
  
  ---
  
  - ### redo log(重做日志)
    - redo log的背景
      >
      > innodb存储引擎的数据最终都是存放在磁盘中，但每次读写数据都需要磁盘IO，效率低下。为此，innodb提供了缓存(Buffer Pool)，Buffer Pool中包含了磁盘中部分数据页的映射，作为访问数据库的缓冲: 当从数据库读取数据时，会先从Buffer Pool中读取，如果Buffer Pool中没有，则从磁盘读取后放入Buffer Pool；当写入数据时，会首先写入Buffer Pool，Buffer Pool中修改的数据会定期刷新到磁盘中(该过程称为刷脏)；
      > 
      > Buffer Pool提高了读写数据的效率，但存在问题：如果mysql宕机，而此时Buffer Pool中修改的数据还没有刷新到磁盘，就会导致数据的丢失，事务的持久性无法保证
      > 
      > redo log被引入解决这个问题：当数据修改时，除了修改Buffer Pool中的数据，还会在redo log记录这次操作；当事务提交时，会调用fsync接口对redo log进行刷盘。如果mysql宕机，重启时可以读取redo log中的数据，对数据进行恢复。redo log采用WAL(write-ahead logging 预写式日志)，所有修改先写入日志，在更新到Buffer Pool，保证数据不会因为mysql宕机而丢失，从而满足持久性要求。
      > 
      > redo log也需要在事务提交时将日志写入磁盘，为什么比直接将Buffer Pool中修改的数据写入磁盘(刷脏)快呢？主要有以下两个原因
      > 1. 刷脏是随机IO，因为每次修改的数据位置随机，但写redo log是追加操作，属于顺序IO
      > 2. 刷脏是以数据页(page)为单位的，mysql默认页大小=16KB，一个Page上一个小修改都要整页写入，而redo log中只包含真正需要写入的部分，无效IO大大减少。
      > 
      > 事务提交的默认策略是fsync对redo log进行刷盘，还可以通过修改 innodb_flush_log_at_trx_commit参数改变策略，但事务的持久性将无法保证。
  
- redo log的存储方式:
      - redo log是固定大小的，如可配置为一组4个文件，每个文件的大小为1G，总共就有4G文件去记录，从头开始写，写到末尾就又回到开头循环写。
      - write pos是当前记录的位置，一边写一边后移，当写到最后一个文件的末尾的时候，会回到第一块开头开始写。checkpoint是当前要释放的位置，释放记录前要把记录更新到数据文件。如果write pos追上checkpoint，表明全部空间满了，不能执行新的更新，得停下来释放掉一些位置，让checkpoint继续推进
      - 当有一条数据需要更新的时候，innodb引擎先将数据更新到内存，再把记录写到redo log里面，更新就算完成了。同事 innnodb引擎会在适当的时候，将操作记录更新到磁盘里面

- redo log和binlog的区别
      
      - 作用不同: redo log是用于crash recovery的，保证mysql宕机不影响持久性；binglog是用于point-in-time recovery的，保证服务器可以基于时间点恢复，还可用于主从复制
      - 层次不同: redo log是innodb存储引擎实现的，而binlog是mysql服务层的，同时支持其他存储引擎。
      - 内容不同: redo log是物理日志，内容基于磁盘的page;binlog的内容是二进制日志，根据binlog_format参数的不同，可能基于sql语句、基于数据本身或者二者的混合。
      - 写入时机不同: binlog在事务提交时写入；redo log的写入方式多元。
  
- redo log 记录流程
    插入/更新的时候，存储引擎将数据更新到内存 buffer pool，同时将这个更新操作记录到redo log里，此时的redo log处于prepare状态。然后告知执行器执行完成了，随时可以提交事务。执行器生成这个操作的binlog，把binlog写入磁盘。执行器调用引擎的提交事务的接口，引擎把刚刚写入的redo log状态更改成提交 commit 状态。如果设置了innodb_flush_log_at_trx_commit=1，则会把redo log写入到 log on disk
    
    先写redo，后写binlog；会话发起commit动作，存储引擎层开启[Prepare]状态，在对应的redo日志记录上打上prepare标记，写入binlog并执行sync刷盘。在redo日志记录上打上commit标记表示记录提交完成

- innodb_flush_log_at_trx_commit 设置
  - innodb_flush_log_at_trx_commit=0，在提交事务时，InnoDB不会立即触发将缓存日志写到磁盘文件的操作，而是每秒触发一次缓存日志回写磁盘操作，并调用操作系统fsync刷新IO缓存。
  - innodb_flush_log_at_trx_commit=1，在每个事务提交时，InnoDB立即将缓存中的redo日志回写到日志文件，并调用操作系统fsync刷新IO缓存。
  - innodb_flush_log_at_trx_commit=2，在每个事务提交时，InnoDB立即将缓存中的redo日志回写到日志文件，但并不马上调用fsync来刷新IO缓存，而是每秒只做一次磁盘IO缓存刷新操作。

---

#### MVCC 多版本控制
> https://segmentfault.com/a/1190000037557620
> 

- 通过保存数据在某个时间点的快照 来实现 MVCC 。不管事务执行多长时间，事务内部看到的数据不会受其他事务影响，根据事务开始时间的不同，每个事务看到的快照数据是不一样的。
- 简单说 mvcc的思想就是保存数据的历史版本。
- 解决的问题:
    - 读写之间阻塞的问题: 让读写互相不阻塞，读不阻塞写，写不阻塞读，提高并发的能力
    - 降低死锁概率: innodb的乐观锁采用了乐观锁的方式，读取数据不需要加锁，写数据时直接加对应的行锁即可
    - 解决一致性读的问题: 一致性读即快照读，查询某个时间点的快照时，只能看到这个时间点之前事务提交的结果
- 快照读和当前读
  - 不加锁的简单的 SELECT 都属于快照读
  - 当前读是读取最新数据，而不是历史版本数据 select ** lock in share mode / for update 
- mvcc如何工作的
  - innodb如何记录数据的多个版本的
    - 事务版本号：每开启一个事务，都会从数据库中获得一个事务ID，该ID是自增长的，通过ID大小，判断事务的时间顺序
    - 行记录的隐藏列: DB_ROW_ID 隐藏的行ID，DB_TX_ID 事务ID，DB_ROLL_PTR: 回滚指针，指向记录undo log信息
                     行记录快照保存在undo log中，可以在回滚段中找到，回滚指针将数据行的所有快照通过链表结构串联起来
  - 只靠 MVCC 实现RR隔离级别，可以保证可重复读，还能防止部分幻读，但并不是完全防止。    