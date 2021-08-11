1. 构造方法
	```java
	 public ThreadPoolExecutor(int corePoolSize, //核心线程数量
                              int maximumPoolSize, //最大线程数量
                              long keepAliveTime, //超过core个多余线程的存活时间
                              TimeUnit unit, //时间单位
                              BlockingQueue<Runnable> workQueue, //任务队列，缓存被提交但没有被执行的线程
                              ThreadFactory threadFactory, // 线程工厂，指定线程池名称等
                              RejectedExecutionHandler handler // 拒绝策略) {
        this(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue,
             Executors.defaultThreadFactory(), handler);
    }
	```
    corePoolSize: 指定了线程池中的线程数量，它的数量决定了添加的任务是开辟新的线程去执行，还是放到workqueue任务队列中。
    maximumPoolSize: 指定了线程池中的最大线程数量，这个参数会根据你使用的workqueue任务队列的类型，决定线程池会开辟的最大线程数量
    keepAliveTime: 当线程池中线程数量大于core数量时，剩余的空闲线程在终止前等待新任务的最长时间
    workqueue: 任务队列，被添加到线程池中，但尚未被执行的任务。分为直接提交队列，有界任务队列，无界任务队列，有限任务队列等

2. execute方法
	``` java
   if (command == null)
            throw new NullPointerException();
        int c = ctl.get();
        if (workerCountOf(c) < corePoolSize) {
            if (addWorker(command, true))
                return;
            c = ctl.get();
        }
        if (isRunning(c) && workQueue.offer(command)) {
            int recheck = ctl.get();
            if (! isRunning(recheck) && remove(command))
                reject(command);
            else if (workerCountOf(recheck) == 0)
                addWorker(null, false);
        }
        else if (!addWorker(command, false))
            reject(command);
   ```
   方法执行流程:
   1. 首先获取ctl的状态，该状态表示当前线程池的状态或者线程池中的数量
   2. 如果当前线程数小于核心线程数，尝试添加到workerqueue队列中，添加到队列成功，直接返回，添加不成功，继续获取ctl的值
   3. 判断当前ctl是否是运行状态，在运行的话，尝试添加到队列中。队列也添加成功的话，进行ctl的再次检查(防止此时线程被停止)。如果线程池被关闭了，那么在线程池中移除线程，并且直接返回拒绝。如果线程池未关闭，则检查现在的worker数量是否等于0，等于0添加worker中一个null
   4. 如果ctl时关闭状态，或者向队列中添加失败，尝试直接向worker中启动一个线程，如果启动失败，则直接返回拒绝。
----
3. workQueue,线程池中的任务队列是一个BlockingQueue接口的对象，只存放Runnable对象。根据队列功能，分为以下几类
	|name|说明|
	|----|----|
	|SynchronousQueue|直接提交队列:没有容量，每一个插入操作都要等待一个响应的删除操作。通常需要将maximumPoolSize的值设置很大，否则很容易出发拒绝策略  https://blog.csdn.net/yanyan19880509/article/details/52562039|
	|ArrayBlockingQueue|有界的任务队列:任务大小通过入参 int capacity决定，当填满队列后才会创建大于corePoolSize的线程|
	|LinkedBlockingQuque|无界的任务队列:线程个数最大为corePoolSize,如果任务过多，则不断扩充队列，直到内存资源耗尽|
	|PriorityBlockingQueue|优先任务队列:无界的特殊队列，可以控制任务只从的先后顺序，而上面几个都是先进先出的策略|
----
4. 拒绝策略:如果线程池处理速度达不到任务的出现速度，只能执行拒绝策略
	|策略名称|描述|
	|----|----|
	|AbortPolicy|该策略会直接抛出异常，阻止系统正常工作，线程池默认使用该策略|
	|CallerRunsPolicy|只要线程池未关闭，该策略直接再调用者线程中，运行当前被丢弃的任务|
	|DiscardOldestPolicy|该策略将丢弃最老的一个请求，也就是即将被执行的一个任务，并尝试重新提交当前任务|
	|DiscardPolicy|该策略默默地丢弃无法处理的任务，不予任务处理|
----
5. 线程池线程数的设置
	cpu密集型的任务 一般设置 线程数 = 核心数N + 1 (常见的为 加解密、压缩解压缩、搜索排序等业务是CPU密集型的业务)
	io密集型的任务 一般设置 线程数 = 核心数N*2 + 1
	如果都存在，则分开两个线程池
	实际应用中 线程数 = (（线程CPU时间+线程等待时间）/ 线程CPU时间 ) * 核心数N
	一般来说，非CPU密集型的业务，瓶颈都在后端数据库，本地cpu计算的时间很少，设置几十或者几百个工作线程也是有可能的
----
6. 
	

