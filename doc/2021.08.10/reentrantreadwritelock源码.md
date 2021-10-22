### 类结构介绍:
	ReentrantReadWriteLock 中维护了两把锁，一个是 ReadLock(内部类) , 一个是 WriteLock(内部类) . 
	内部类Sync 还继承了 AQS ，对同步队列的操作做了进一步的封装。
		aqs中使用state来记录当前锁的状态，但在读写锁中，由于存在读锁和写锁，单独用一个state就无法满足当前是有写锁还是读锁了，所以对state做了额外的拆解
		``` java
			// 版本序列号
				private static final long serialVersionUID = 6317671515068378041L;        
				// 高16位为读锁，低16位为写锁
				static final int SHARED_SHIFT   = 16;
				// 读锁单位
				static final int SHARED_UNIT    = (1 << SHARED_SHIFT);
				// 读锁最大数量
				static final int MAX_COUNT      = (1 << SHARED_SHIFT) - 1;
				// 写锁最大数量
				static final int EXCLUSIVE_MASK = (1 << SHARED_SHIFT) - 1;
				// 本地线程计数器
				// 该线程器内部是由ThreadLocal实现的，由于每个线程都需要记录获取的读锁的次数，
				// 所以此处采用了ThreadLocal来记录每个线程对应的count次数，仅对本线程可见
				private transient ThreadLocalHoldCounter readHolds;
				// 缓存的计数器
				private transient HoldCounter cachedHoldCounter;
				// 第一个读线程
				private transient Thread firstReader = null;
				// 第一个读线程的计数
				private transient int firstReaderHoldCount;
		```
		将state拆分成了高16位和低16位，高16位代表读锁，低16位代表写锁，以此来判定写锁状态还是读锁状态
		同时，sync中还定义了两组变量 firstReader,firstReaderHoldCount和readHolds,cachedHoldCounter。
		这两组变量分别代表了第一次获取读锁的线程和最后一次获取读锁的线程。
	FairSync和NonFairSync 分别继承了Sync，分为公平锁和非公平锁

### 写锁

```java
/**
 * 加锁
 */
public void lock() {
		sync.acquire(1);
		}
		
		// AQS中通用方法
public final void acquire(int arg) {
    	// tryAcquire根据各实现类调用对应的方法
		if (!tryAcquire(arg) && 
		// tryAcquire返回false代表没有获取到锁，那么进入aqs 的排队，和ReentantLock的内容一致
		acquireQueued(addWaiter(Node.EXCLUSIVE), arg))
		selfInterrupt();
		}
		// ReentrantReadWriteLock的内部类Sync类中
protected final boolean tryAcquire(int acquires) {
		/*
		 * Walkthrough:
		 * 1. If read count nonzero or write count nonzero
		 *    and owner is a different thread, fail.
		 * 2. If count would saturate, fail. (This can only
		 *    happen if count is already nonzero.)
		 * 3. Otherwise, this thread is eligible for lock if
		 *    it is either a reentrant acquire or
		 *    queue policy allows it. If so, update state
		 *    and set owner.
		 */
		// 当前线程
		Thread current = Thread.currentThread();
		// 获取当前的state状态
		int c = getState();
		// 获取独占锁(写锁)的个数
		int w = exclusiveCount(c);
		// 如果 state状态不等于0 ，代表有线程对锁进行了占用，那么只能判断可不可以重入
		if (c != 0) {
		    
			// (Note: if c != 0 and w == 0 then shared count != 0)
			// w 等于0 ，代表 没有写锁 ,写锁和读锁互斥，所以需要返回false
			// 后一项代表当前线程和持有锁的线程不一致 ，写锁互斥，返回false
			// 只有 w!=0 ,current=ExclusiveOwner才会让这个条件为false，不返回false，代表有写锁，并且线程相等，继续向下执行代表重入
			if (w == 0 || current != getExclusiveOwnerThread())
				return false;
			// 判断写锁的次数是不是超次数了(65535)
			if (w + exclusiveCount(acquires) > MAX_COUNT)
				throw new Error("Maximum lock count exceeded");
			// Reentrant acquire
			//设置state，写锁重入
			setState(c + acquires);
			return true;
		}
		// c ==0 走这个逻辑，代表没有线程占用当前锁，该线程可以直接给这个锁加锁
		if (writerShouldBlock() ||
			!compareAndSetState(c, c + acquires))
			return false;
		setExclusiveOwnerThread(current);
		return true;
		}
		// 该方法计算写锁的个数
static int exclusiveCount(int c) { return c & EXCLUSIVE_MASK; }
// 公平锁的 writerShouldBlock方法，调用了 hasQueuedPredecessors方法，
final boolean writerShouldBlock(){
		return hasQueuedPredecessors();
		}
// 非公平锁的writerShouldBlock方法直接返回false，直接去竞争锁
final boolean writerShouldBlock() {
		return false; // writers can always barge
		}

/**
* 解锁
*/
public void unlock() {
		sync.release(1);
		}
public final boolean release(int arg) {
		if (tryRelease(arg)) {
		    // 解锁成功之后，应该是为了unpark后续的线程
			Node h = head;
			if (h != null && h.waitStatus != 0)
				unparkSuccessor(h);
			return true;
		}
		return false;
		}

		// ReentrantReadWriteLock中的sync内部类
// 释放的方法其实就是让state还原。但必须是上锁的线程才可以还原。如果上锁的线程还原之后state仍然不为0，那么代表当前线程正处于重入的状态
protected final boolean tryRelease(int releases) {
    	// 第一个if ，只能同一个线程进行解锁，不允许其他线程解锁
		if (!isHeldExclusively())
			throw new IllegalMonitorStateException();
		//释放锁之后的状态
		int nextc = getState() - releases;
		// 判断当前写锁的数量是否等于0了
		boolean free = exclusiveCount(nextc) == 0;
		// 如果写锁的数量等于0了，那么独占锁设置为null
		if (free)
			setExclusiveOwnerThread(null);
		// 重新设置state
		setState(nextc);
		return free;
		}
protected final boolean isHeldExclusively() {
		// While we must in general read state before owner,
		// we don't need to do so to check if current thread is owner
		return getExclusiveOwnerThread() == Thread.currentThread();
		}
```

---

###读锁

	读锁要比写锁复杂

```java
/**
 * 加锁
 */
public void lock() {
		sync.acquireShared(1);
		}

public final void acquireShared(int arg) {
    	// 尝试获取贡献锁
		if (tryAcquireShared(arg) < 0)
		    //获取共享锁失败，排队获取共享锁
			doAcquireShared(arg);
		}

protected final int tryAcquireShared(int unused) {
		/*
		 * Walkthrough:
		 * 1. If write lock held by another thread, fail.
		 * 2. Otherwise, this thread is eligible for
		 *    lock wrt state, so ask if it should block
		 *    because of queue policy. If not, try
		 *    to grant by CASing state and updating count.
		 *    Note that step does not check for reentrant
		 *    acquires, which is postponed to full version
		 *    to avoid having to check hold count in
		 *    the more typical non-reentrant case.
		 * 3. If step 2 fails either because thread
		 *    apparently not eligible or CAS fails or count
		 *    saturated, chain to version with full retry loop.
		 */
		Thread current = Thread.currentThread();
		// 获取当前state状态
		int c = getState();
		// 如果 写锁数量!=0 ,并且当前线程和持有锁的线程还不想等，直接返回-1.
		// 因为读写锁可以存在锁降级的情况，但如果是不同的线程占有着写锁，那么读锁会直接互斥
		if (exclusiveCount(c) != 0 &&
			getExclusiveOwnerThread() != current)
			return -1;
		// 获取共享锁的数量
		int r = sharedCount(c);
		if (!readerShouldBlock() && // 查看读锁是不是应该被阻塞，返回false，不被阻塞继续往下走
			r < MAX_COUNT && // 读锁个数是否达到了最大值
			compareAndSetState(c, c + SHARED_UNIT)) { // cas获取锁
		    // if三个条件都fanhuitrue，代表当前线程获取了对应的锁，进行下面的操作
			if (r == 0) {
			    // r==0代表当前线程是第一个加读锁的线程，记录到变量中
				firstReader = current;
				firstReaderHoldCount = 1;
			} else if (firstReader == current) {
			    // 如果读锁的数量不等于0，但是 当前加读锁的线程是第一个线程，那么直接给第一个线程加读锁数量
				firstReaderHoldCount++;
			} else {
			    // 如果 r != 0 && firstReader != current ， 代表是其他线程进行了加读锁的操作
				//获取最后一次的 HoldCounter
				// rh = null 代表 HoldCounter第一次初始化，直接创建
				// rh.tid != getThreadId(current)代表线程不同，也需要新创建一个对象
				// 如果 rh != null && rh.tid == getThreadId(current) ，其实进入的线程就是最后一个线程，直接操作变量就可以了
				HoldCounter rh = cachedHoldCounter;
				if (rh == null || rh.tid != getThreadId(current))
					cachedHoldCounter = rh = readHolds.get();
				else if (rh.count == 0)
					readHolds.set(rh);
				rh.count++;
			}
			return 1;
		}
		// 如果读锁的第一个判断 readerShouldBlock 方法直接返回了true，那会直接进入下面的方法，进行阻塞获取读锁
		return fullTryAcquireShared(current);
}

/**
 * Full version of acquire for reads, that handles CAS misses
 * and reentrant reads not dealt with in tryAcquireShared.
 */
final int fullTryAcquireShared(Thread current) {
		/*
		 * This code is in part redundant with that in
		 * tryAcquireShared but is simpler overall by not
		 * complicating tryAcquireShared with interactions between
		 * retries and lazily reading hold counts.
		 */
		HoldCounter rh = null;
		for (;;) {
			int c = getState();
			if (exclusiveCount(c) != 0) {
				if (getExclusiveOwnerThread() != current)
					return -1;
				// else we hold the exclusive lock; blocking here
				// would cause deadlock.
			} else if (readerShouldBlock()) {
				// Make sure we're not acquiring read lock reentrantly
				if (firstReader == current) {
					// assert firstReaderHoldCount > 0;
				} else {
					if (rh == null) {
						rh = cachedHoldCounter;
						if (rh == null || rh.tid != getThreadId(current)) {
							rh = readHolds.get();
							if (rh.count == 0)
							readHolds.remove();
						}
					}
					if (rh.count == 0)
					return -1;
				}
			}
			if (sharedCount(c) == MAX_COUNT)
				throw new Error("Maximum lock count exceeded");
			if (compareAndSetState(c, c + SHARED_UNIT)) {
				if (sharedCount(c) == 0) {
					firstReader = current;
					firstReaderHoldCount = 1;
				} else if (firstReader == current) {
					firstReaderHoldCount++;
				} else {
					if (rh == null)
						rh = cachedHoldCounter;
					if (rh == null || rh.tid != getThreadId(current))
						rh = readHolds.get();
					else if (rh.count == 0)
						readHolds.set(rh);
					rh.count++;
					cachedHoldCounter = rh; // cache for release
				}
				return 1;
			}
		}
}

// 公平锁的 readShouldBlock方法，直接判断队列是不是空
final boolean readerShouldBlock() {
		return hasQueuedPredecessors();
		}
// 非公平锁 的readShouldBlock方法，
final boolean readerShouldBlock() {
		/* As a heuristic to avoid indefinite writer starvation,
		 * block if the thread that momentarily appears to be head
		 * of queue, if one exists, is a waiting writer.  This is
		 * only a probabilistic effect since a new reader will not
		 * block if there is a waiting writer behind other enabled
		 * readers that have not yet drained from the queue.
		 */
		return apparentlyFirstQueuedIsExclusive();
		}
final boolean apparentlyFirstQueuedIsExclusive() {
		Node h, s;
		return (h = head) != null &&
			(s = h.next)  != null &&
			!s.isShared()         &&
			s.thread != null;
		}

```
