```java
public final void acquire(int arg) {
    if (!tryAcquire(arg) &&  // 尝试获取线程，返回true，代表获取到了，if结束
    						 // 返回false，代表获取失败，走if下一个判断，入队
          acquireQueued(	 // 队列中的节点尝试获取锁
              addWaiter(Node.EXCLUSIVE), arg)  // addWaiter方法 ，当前线程入队列，并返回一个aqs队列，如果队列为空，则创建一个空的node节点，将当前节点设置为队尾
       		)
          selfInterrupt();
}
```

```java
// ReentrantLock#FairSync ReentrantLock类的FariSync内部类
protected final boolean tryAcquire(int acquires) {
			// 获取当前线程
            final Thread current = Thread.currentThread();
            // 获取当前的锁的state状态
            int c = getState();
            if (c == 0) {
            // c=0，代表没有人竞争锁，尝试竞争。c=0的状态可以理解为锁刚开始初始化，还没有线程持有过锁；或者锁刚刚被释放，还没有线程竞争到(一个临界点)
                if (!hasQueuedPredecessors() && // 该方法判断队列中是否有前置节点，如果没有前置节点，返回false，代表整个aqs为空，当前线程可以直接抢占锁，接着if，返回ture，代表代表队列不为空，应该从队尾拿节点进行线程的竞争，因为此时是公平锁
                    compareAndSetState(0, acquires)) { // 尝试更改state状态，即加锁
                    setExclusiveOwnerThread(current);   //设置独占的线程为当前线程
                    return true;
                }
            }
            // 如果c!=0,则锁已经有竞争线程，看是否是可重入的，如果是，则state+1
            else if (current == getExclusiveOwnerThread()) {
                int nextc = c + acquires;
                if (nextc < 0)
                    throw new Error("Maximum lock count exceeded");
                setState(nextc);
                return true;
            }
            // 默认返回false，尝试获取锁失败
            return false;
        }
```

```java
//Queries whether any threads have been waiting to acquire longer than the current thread. 翻译: 查询是否有比当前线程等待时间还长的线程
// AbstractQueuedSynchronizer类
// 1.aqs队列还没有初始化: 头和尾都是空，那么h!=t条件不成立，直接返回false，线程可以直接进行抢占
// 2.aqs队列有了节点，但此时，额外的一个新建的线程来抢夺，h！=t为true，h.next==null为false，s.thread != currentThread 为true 整体返回true，额外的线程需要入队才可以继续进行
public final boolean hasQueuedPredecessors() {
        // The correctness of this depends on head being initialized
        // before tail and on head.next being accurate if the current
        // thread is first in queue.
        Node t = tail; // Read fields in reverse initialization order
        Node h = head;
        Node s;
        return h != t &&
            ((s = h.next) == null || s.thread != Thread.currentThread()); // 后一个括号内的判断，判断头节点后的下一个节点是不是当前节点，如果是当前持有线程的节点，也可以直接竞争
    }
    
```


```java
// 初始化aqs队列，如果队列为空，创建一个空的节点，如果不为空，将当前节点加入到aqs队列的尾部
// AbstractQueuedSynchronizer类 Node.Exclusive是独占锁，Node.SHARED共享锁
private Node addWaiter(Node mode) { 
		// 封装当前节点为node
        Node node = new Node(Thread.currentThread(), mode);
        // Try the fast path of enq; backup to full enq on failure
        // 查看队尾，初始化的时候 tail == null，所以会直接走enq方法
        // 当aqs初始化之后，就会直接进入if判断，直接将当前节点设置为队尾，返回当前节点
        Node pred = tail;
        if (pred != null) {
            node.prev = pred;
            if (compareAndSetTail(pred, node)) {
                pred.next = node;
                return node;
            }
        }
        // 队尾为空，初始化队列
        enq(node);
        return node;
    }

```

```java
	// 初始化队列。设置头节点，头节点是一个虚拟节点，里面不存线程信息，主要作用就是为了判断队列是不是完成，头节点后有没有节点，当前节点是不是应该自旋等待竞争；并将当前线程封装的节点设置为队尾
    private Node enq(final Node node) {
        for (;;) { // 死循环
            Node t = tail; //查找队尾
            if (t == null) { // Must initialize 队尾为空的话，初始化aqs队列
                if (compareAndSetHead(new Node())) //此处将一个空的节点设置为了队头
                    tail = head; // 头尾节点相等
            } else { // 第一次循环之后 尾节点已经不为空了，那么就开始将当前线程所在的节点设置为尾节点
                node.prev = t;
                if (compareAndSetTail(t, node)) {
                    t.next = node;
                    return t;
                }
            }
        }
    }
```


```java
	// 队列中的节点尝试获取锁
    final boolean acquireQueued(final Node node, int arg) {
        boolean failed = true;
        try {
            boolean interrupted = false;
            for (;;) { //死循环，一直判断
                final Node p = node.predecessor(); //获取当前节点的前置节点
                // if判断有两个条件
                // p==head 代表着必须是第二个节点，这个是先觉条件，如果 p!=head ，那么直接跳过当前判断了
                // 如果是第二个节点，则尝试获取锁，获取锁成功，直接将当前节点设置为头节点，并且让头节点为空，帮助gc 
                // 这个地方，只有第二个节点才会进行竞争，也就是公平锁的原因
                if (p == head && tryAcquire(arg)) { 
                    setHead(node);
                    p.next = null; // help GC
                    failed = false; // 
                    return interrupted;
                }
                // 当前节点的前置节点不是头节点，进入下面if
                // 第一个条件判断在尝试获取失败之后，是不是应该park(睡眠)。第一次会返回一个false，但会标注头节点的waitStatus为-1，第二次在进入就会返回true，进入if的第二个判定。
                if (shouldParkAfterFailedAcquire(p, node) &&
                    parkAndCheckInterrupt())
                    interrupted = true;
            }
        } finally {
            if (failed)
                cancelAcquire(node);
        }
    }
    
    // 设置头节点方法
   private void setHead(Node node) {
        head = node;  // 头=当前节点，节点的线程为空，前置节点为空
        node.thread = null; 
        node.prev = null;
    }


private static boolean shouldParkAfterFailedAcquire(Node pred, Node node) {  // pred:前一个节点，node:当前节点
        int ws = pred.waitStatus;  //获取前一个节点的waitStatus，默认为0.当第一次进来的时候，获取的是头节点的waitStatus，那么为0
        if (ws == Node.SIGNAL)  //如果 waitStatus = -1 ,返回true ，如果前一个节点的状态为-1 ，那么相当于说前一个节点已经在park了，那么当前节点就等待前一个节点park结束即可，当前节点其实也是在park中
            /*
             * This node has already set status asking a release
             * to signal it, so it can safely park.
             */
            return true;
        if (ws > 0) {   // 如果 waitStatus > 0 ,走下面的逻辑
            /*
             * Predecessor was cancelled. Skip over predecessors and
             * indicate retry.
             */
            do {
                node.prev = pred = pred.prev;
            } while (pred.waitStatus > 0);
            pred.next = node;
        } else {   //如果 waitStatus == 0 ，则将pred的节点的waitStatus状态设置为-1，走这段的逻辑代表前一个节点目前还没有进入park，要让前一个节点进去park
            /*
             * waitStatus must be 0 or PROPAGATE.  Indicate that we
             * need a signal, but don't park yet.  Caller will need to
             * retry to make sure it cannot acquire before parking.
             */
            compareAndSetWaitStatus(pred, ws, Node.SIGNAL);
        }
        return false;
    }
	
	//该方法内部调用了LockSupport的park方法，让当前线程进行停止，当停止结束之后，返回一个线程是否被打断
    // 该方法在正常的 lock方法中基本上没有什么意义。但在 lockInterruptibly 方法中，接着调用了doAcquireInterruptibly方法，如果当前线程被打断，则会抛出被打断的异常。同时，如果上锁是调用的是 lockInterruptibly 方法，那么当被interrupt的时候，会直接被唤醒
    private final boolean parkAndCheckInterrupt() {
        LockSupport.park(this);
        // 当解锁调用unpark成功之后，会返回当前线程的中断状态，但为了保持中断状态一致，accquire方法中，还调用了selfInterrupt() 方法，重新标记当前线程的中断状态
        return Thread.interrupted();
    }
```


---

解锁:
	解锁会调用unlock方法，然后调用对应的 sync.release(1) 的方法

```java
	// 对reentrantlock解锁
	// AbstractQueuedSynchronizer 类
	public final boolean release(int arg) {
        if (tryRelease(arg)) { //首先尝试释放锁，释放成功则进入代码块
            Node h = head; // 记录头节点
            // 此处分为几种情况
            // 1. 如果aqs队列还没有初始化，即只有一个线程在获取锁，那么直接返回true (h!=null不成立)
            // 2. 如果 h!=null ，那么代表此时aqs中有节点在等待，
            // 		如果 h节点的waitStatus = -1 ,则代表线程正在park，需要唤醒，则进入unparkSuccessor方法
            //		如果 h节点的waitStatus = 0 ，表示队列中只有一个 头节点，其他节点还未加入队列中，那么其他线程可以直接获得锁
            if (h != null && h.waitStatus != 0)
            // 对满足条件的节点进行unpark操作
                unparkSuccessor(h);
            // 只要尝试释放锁成功，就会返回true
            return true;
        }
        // 如果尝试释放锁失败，直接返回false
        return false;
    }
    
    
    // 尝试释放锁
    // ReentrantLock类中 ， releases = 1
    protected final boolean tryRelease(int releases) {
    		// 获取减完之后的state状态
            int c = getState() - releases;
            // 该if表示，如果当前执行unlock的线程 不等于 占有锁的线程，抛出违法异常。出现这种情况的原因可能是 线程t2中的reentrantlock 没有上锁，就进行了解锁
            if (Thread.currentThread() != getExclusiveOwnerThread())
                throw new IllegalMonitorStateException();
            // 记录释放是否成功
            boolean free = false;
            // c==0,锁释放成功，设置当前占有的锁的线程为null
            if (c == 0) {
                free = true;
                setExclusiveOwnerThread(null);
            }
            // 重新设置state。如果 计算 完 c 仍然大于0 ，那么是重入状态，继续进行解锁即可
            setState(c);
            return free;
        }
        
        // 进行线程节点 的unpark，其中参数node是当前aqs队列的头节点
        // AbstractQueuedSynchronizer 类
  private void unparkSuccessor(Node node) {
        /*
         * If status is negative (i.e., possibly needing signal) try
         * to clear in anticipation of signalling.  It is OK if this
         * fails or if status is changed by waiting thread.
         */
         // 头节点的ws状态
        int ws = node.waitStatus;
        // 如果ws 小于 0 ，即 -1 ，则将节点的ws更改为0
        if (ws < 0)
            compareAndSetWaitStatus(node, ws, 0);

        /*
         * Thread to unpark is held in successor, which is normally
         * just the next node.  But if cancelled or apparently null,
         * traverse backwards from tail to find the actual
         * non-cancelled successor.
         */
         // 获取头节点的下一个节点
        Node s = node.next;
        // 下一个节点为空或者节点的 ws 大于0 ，执行以下代码，会从队尾中拿ws小于0 的节点
        // 下一个节点为空，那么就是队列中只有一个头节点，没有其他节点
        // 下一个节点不为空，并且 对应节点的 ws 值 大于0 ，ws大于0只有 取消状态 才有(CANCELLED =  1),这两个条件出现的情况都比较苛刻，一般不太会出现
        if (s == null || s.waitStatus > 0) {
            s = null;
            for (Node t = tail; t != null && t != node; t = t.prev)
                if (t.waitStatus <= 0)
                    s = t;
        }
        // 如果 下一个节点不为空，那么唤醒下一个线程，调用unpark方法，
        if (s != null)
            LockSupport.unpark(s.thread);
    }

```