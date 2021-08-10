### nacos配置动态刷新源码学习
---
> 主要参考链接 https://www.jianshu.com/p/38b5452c9fec
>

```java
        String serverAddr = "localhost";
        String dataId = "provider.yaml";
        String group = "DEFAULT_GROUP";
        Properties properties = new Properties();
        properties.put("serverAddr", serverAddr);
        ConfigService configService = NacosFactory.createConfigService(properties);
        String content = configService.getConfig(dataId, group, 5000);
        System.out.println("first receive:" + content);
        configService.addListener(dataId, group, new Listener() {
            public Executor getExecutor() {
                return null;
            }

            public void receiveConfigInfo(String configInfo) {
                System.out.println("currentTime:" + new Date
                        () + ", receive: " + configInfo);
            }
        });
        int n = System.in.read();
```
以上代码为动态配置得main方法模拟。

1. 配置Properties之后，由NacosFactory调用createConfigService方法，进入ConfigFactory.createConfigService方法。然后会通过反射调用com.alibaba.nacos.client.config.NacosConfigService得构造方法。

2. NacosConfigService构造方法中，先initNameSpace初始化namespace，然后构造ServiceHttpAgent，serverhttpagent中设置了ServerList，securityProxy等，并且创建了一个 scheduledThreadPool定时登录。

3. NacosConfigService中接下来创建了一个ClientWorker实体，(clientworker上注解说明是一个long polling)该实体内部先进行init properties ，包括timeout等，以及一个executor，executorService, 和最重要得定时任务得执行。定时任务中会每隔10s 调用checkConfigInfo方法。

4. checkConfigInfo方法中，先获取了cacheMap得size(一共多少个任务)，然后计算每个任务得数量，紧接着创建了一个LongPollingRunnable线程，开始执行线程。

5. LongPollingRunnable 中得run方法逻辑

   a. 先获取本地配置，通过checkLocalConfig方法获取本地得配置信息。本地得信息通过文件存储，存储路径位于 /nacos/config/server_nacos/snapotshot/#{namespace}下，读取local得配置，放置于cacheData中，如果cacheData使用的是本地配置，调用checkListernerMD5方法，检验当前的md5和cacheData内部持有的md5是否一致。

   b. 检查服务器端的配置,先调用checkUpdateDataIds方法，获取哪些 服务的group进行了变更 。实质上是通过http调用nacos服务端的listener的方法，该方法的默认超时时间是30s。然后遍历这个变更的group，通过getServerConfig方法，获取更新后的config，然后放置到对应CacheData中，同时更新此时的md5值。然后遍历所有的cacheData,调用chekcListernerMd5方法，查看md5是否相同，然后重新通过execute方法执行。在checkListernerMd5得方法中，如果md5和listerners中的md5不同，会调用safeNotifyListener方法，内部会创建一个Runnable方法，其内部会获取listener的监听(在初始化的时候就会创建这个监听，为了后期的动态刷新)，然后listener监听最终调用对应的reviceConfigInfo方法，receiveConfigInfo方法由自己实现。
6. 通过以上5个步骤，可以了解到 客户端是通过http请求的方式获取服务端配置的更新，并且给了30s的等待时间。下面分析一下 服务端。
7. 客户端获取远程配置的时候，会调用服务端的listener方法。listener方法中，会调用inner.doPollingConfig方法，进行定时长轮询等待。接着会调用LongPollingService的addLongPollingClient方法，创建一个ClientLongPolling实体(此处有一个timeout,是29.5s，让结果提前返回)，通过scheduled线程开始执行
8. ClientLongPolling的run方法中，开始一个定时得线程，时间为29.5s，然后把这个this放入到allSubs的quene中，当时间到了之后，先查看自己是否还在allSubs中(有可能提前被手动修改而移除)，然后获取服务端保存的客户端的groupkey，检查是否有变更，返回结果。
9. 除了客户端主动拉取，服务端当更新配置的时候，也会推送给客户端。
10. 服务端提交配置，先进行持久化，然后调用ConfigChangePublisher的notifyConfigChange方法(首先会构造一个ConfigDataChangeEvent)，接着调用NotifyCenter.publishEvent方法，然后获取对应的topic，获取对应topic 的EventPublisher,将时间发布出去。发布的时候先添加到queue(BlockQueue)中，如果失败，在调用receiveEvent方法，调用notifySubscriber方法，唤醒订阅者。
11. 主动更新配置后，会通过EventPublisher将配置发布出去，那客户端是如何接收 的呢。
12. 当客户端调用服务端的listener方法时，会初始化LongPollingService，此时会创建allSubs的ConcurrentLinkedQueue，然后调用NotifyCenter的RegisterSubscriber方法以及该RegisterToPublisher方法。当受到Subscrber时候，会调用OnEvent方法，通过DataChangeTask任务，将结果通过response返回回去(该任务中会遍历allsubs队列，拿到对应的ClinetLongPolling实例，先删除该实例，在发送请求)

在项目中，Nacos是通过NacosContextRefsher类进行初始化的。该类实现了ApplicationListener具有监听回调的功能，又实现了ApplicationContextAware类，当初始化的受，就会调用OnAppicationEvent方法，调用registerNacosListenersForApplications方法，该方法会接着调用registerNacosListener，该方法中，就会注册对应Listener，该listener方法中实现了innerReceive方法，收到消息后会调用 applicationContext.publishEvent(RefreshEvent)，发布一个刷新事件，RefreshEventListener收到刷新事件，就会调用对应的 onEvent方法，最终进入到ContextRefresher类中，该类中存在一个RefreshScope,拿到对应的实体，刷新配置

