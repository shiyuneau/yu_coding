# spring源码分析

### XmlBeanFactory构建BeanFactory的主要步骤

- #### XmlBeanFactory的构造方法(解析对应的Xml和创建Bean)

  - XmlBeanDefinitionReader 的 loadBeanDefinitions(resource)方法

  - 调用重载方法loadBeanDefinitions(EncodeResource)方法

  - 调用doLoadBeanDefinitions(InputStream,Resource)方法

  - 先调用doLoadDocument(InputStream,Resource)方法，解析xml，获取xml文件对应的Document

  - 后调用registerBeanDefinitions(Document,Resource)方法 (注册BeanDefinition)

    1.  createBeanDefinitionDocumentReader 先创建BeanDefinitionDocumentReader
    2. getBeanDefinitionCount()
    3. **documentReader.registerBeanDefinitions(Document,XmlReaderContext)注册Bean实例**
  - registerBeanDefinitions方法中，调用doRegisterBeanDefinitions()方法(DefaultBeanDefinitionsDocumentReader)
    1. preProcess 前置方法，可重载实现
    2. **parseBeanDefinitions 解析Bean**
    3. postProcess后置方法，可重载实现
  - parseBeanDefinitions方法结构,主要parseDefaultElement()默认解析元素
    1. importBeanDefinitionResource 解析 import标签
    2. processAiasRegistration 解析 alias标签
    3. **processBeanDefinition 解析 bean标签 , 主要**
    4. doRegisterBeanDefinition 解析 beans标签
  - processBeanDefinition方法 (bean标签的解析及注册)
    1. parseBeanDefinitionElement 方法，元素解析，返回BeanDefinitionHolder类型的实例Holder。
        该方法中，先提取元素中的id及name属性。进一步调用parseBeanDefinitionElement重载方法，解析其他属性。改方法中，创建了一个ABstractBeanDefinition的Bean，该bean的父接口为BeanDefinition，主要是配置文件<bean>元素标签在容器中的内部表示。parseBeanDefinitionElement方法中，主要是解析元数据、lookup-method、replaced-method、构造函数、property子元素等
    2. decorateBeanDefinitionIfRequired方法
        该方法主要是如果上步返回的holder不为空的情况下，若存在默认标签的子节点下有自定义属性，还需要对自定义标签进行解析
    3.  **BeanDefinitionReaderUtils.registerBeanDefinition方法**
        对解析后的holder进行注册
    4. fireComponentRegistered方法，发出响应事件，通知相关监听器，bean已加载完成
  -  registerBeanDefinition方法 进一步 调用 DefaultListableBeanFactory的registerBeanDefinition方法
  -  DefaultListableBeanFactory方法的registerBeanDefnition方法
    1. validate()方法，对AbstractBeanDefinition的校验
    2. 对已经注册的bean进行处理，看其是否允许被覆盖。
    3. beanName加入缓存
      ```
      this.beanDefinitionMap.put(beanName, beanDefinition);
      ```
    4. 重置所有beanName对应的缓存
---
### BeanFactory.getBean(String beanName)获取bean方法
  - AbstractBeanFactory.getBean方法，继续调用doGetBean方法

  - **ABstractBeanFactory.doGetBean方法**
    
    - transformedBeanName 提取beanname
    - **getSingleton方法**，尝试从缓存中获取或singletonFactories中的ObjectFacotry获取
    - 从缓存中获取的对象不为空，调用getObjectForBeanInstance方法，返回对应的实例，有时候需要调用对应的getObject方法返回具体得实例，该方法实际调用的是doGetObjectFromFactoryBean方法，调用getObject方法后，会调用postProcessObjectFromFactoryBean的后置处理器
    - 从缓存中获取的对象为空，开始创建对象
      1. 原型模式的以来检查 isPrototypeCurrentlyInCreation(beanName)
          只有当单例模式过程才尝试解决循环依赖，prototype模式下循环依赖直接抛出错误
      2. 检测parentBeanFactory
      3. 将存储XML配置文件的GernericBeanDefinition转换为RootBeanDefinition,后续的处理都是针对RootBeanDefinition的
      4. 寻找依赖
      5. 针对不同的scope进行bean的创建
      6. 类型转换
    
  - **getSingleton方法**，三级缓存获取对应的单例实例

    ``` java
    /**
     * singletonObjects: 用于保存BeanName和创建bean实例之间的关系，bean name -> bean instance
     * singletonFactories: 用于保存BeanName和创建bean的工厂之间的关系，bean name -> ObjectFactory
     * earySingletonObjects: 保存BeanName和创建bean实例之间的关系，但和singletonObjects不同，该map是将bean提前暴露出来，为了循环引用检测使用
     * registeredSingletons: 用来保存当前所有已注册的bean
     **/
    protected Object getSingleton(String beanName, boolean allowEarlyReference) {
    	Object singletonObject = this.singletonObjects.get(beanName);
    	if (singletonObject == null && isSingletonCurrentlyInCreation(beanName)) {
    		synchronized (this.singletonObjects) {
    			singletonObject = this.earlySingletonObjects.get(beanName);
    			if (singletonObject == null && allowEarlyReference) {
    				ObjectFactory<?> singletonFactory = this.singletonFactories.get(beanName);
    				if (singletonFactory != null) {
    					singletonObject = singletonFactory.getObject();
    					this.earlySingletonObjects.put(beanName, singletonObject);
    					this.singletonFactories.remove(beanName);
    				}
    			}
    		}
    	}
    	return singletonObject;
    }
    ```
    首先从singletonObjects里获取实例，获取不到，从earlySingletonObjects获取，还获取不到，再从singletonFactories里获取beanName对应的ObjectFactory，调用对应的getObject方法获取bean实例，再存放入earlySingletonObjects中，并且从singletonFactories中移除对应的beanName

  - 创建单例实例(doGetBean方法中)
    ``` java
    // Create bean instance.
    if (mbd.isSingleton()) {
        //getSingleton方法主要是在单例创建的前后做一些准备及处理操作。实际的bean的创建是在createBean方法中
        sharedInstance = getSingleton(beanName, () -> {
            try {
                return createBean(beanName, mbd, args);
            }
            catch (BeansException ex) {
                // Explicitly remove instance from singleton cache: It might have been put there
                // eagerly by the creation process, to allow for circular reference resolution.
                // Also remove any beans that received a temporary reference to the bean.
                destroySingleton(beanName);
                throw ex;
            }
        });
        bean = getObjectForBeanInstance(sharedInstance, name, beanName, mbd);
    }
    ```
   
    - createBean方法，准备创建bean
      1. resolveBeanClass 根据设置的class属性或者根据className来解析class
      
      2. prepareMethodOverrides 对override属性进行标记及验证
      
      3. resovleBeforeInstantiation 给BeanPostProcessors一个机会来返回代理来替代真正的实例。该方法中主要调用两个方法，applyBeanPostProcessorsBeforeInstantiation、applyBeanPostProcessorsAfterInitialization,对后处理器中的所有InstantiationAwareBeanostProcessor类型的后处理器进行postProcessBeforeInstantiation方法和BeanPostProcessor的postProcessAfterInitialization方法的调用.
      如果这两个方法中能返回具体的实力，则直接返回。
      
      4. doCreateBean创建实例
    
  - **doCreateBean方法**，创建bean
    - createBeanInstance 根据执行bean使用对应的策略创建新的实例，返回一个BeanWrapper
      1. 看有没有factoryMethodName属性或者配置factory-method，spring会尝试使用InstantiateUsingFactoryMethod方法根据RootBeanDefinition中的配置生成bean实例
      2. 解析过的话，使用解析好的构造函数方法，不需要再次锁定
      3. 否则，更具参数解析构造函数，如果解析出来的构造函数不等于空，根据解析出来的构造函数创建对象
      4. 使用默认构造器函数构造bean **instantiateBean方法**
      - instantiateBean方法，创建bean的方法调用链
        
        - instantiateBean -> getInstantiationStrategy().instantiate -> BeanUtils.instantiateClass(constructorToUse//获取的构造器) -> ctor.newInstance
        
	      默认的是使用构造器的newInstance方法
	- 检测单例是否需要提前曝光。曝光的依据: 单例&允许循环依赖&当前bean正在创建中，检测循环依赖
	  ``` java
      // Eagerly cache singletons to be able to resolve circular references
    	// even when triggered by lifecycle interfaces like BeanFactoryAware.
    	boolean earlySingletonExposure = (mbd.isSingleton() && this.allowCircularReferences &&
    			isSingletonCurrentlyInCreation(beanName));
      if (earlySingletonExposure) {
      		if (logger.isTraceEnabled()) {
      			logger.trace("Eagerly caching bean '" + beanName +
      					"' to allow for resolving potential circular references");
      		}
          //允许提前暴露的话，将对象的singletonFactory暴露出去
      		addSingletonFactory(beanName, () -> getEarlyBeanReference(beanName, mbd, bean));
      	}
      ```
    - populateBean 对bean进行填充，将各个属性值注入，还会递归初始化依赖的bean
      1. InstantiationAwareBeanPostProcessor处理器的postProcessAfterInstantiation函数，控制程序是否继续进行属性填充，可以终止后续的属性填充
      2. autowireByName 根据名称自动注入
      3. autowireByType 根据类型自动注入
      4. 应用InstantiationAwareBeanPostProcessor处理器的postProcessPropertyValues方法，对属性获取完毕填充前堆属性再次处理
    - initializeBean 调用初始化方法 如 init-method
      1. invokeAwareMethods 
          Spring中提供了一些Aware相关接口(BeanFactoryAware、ApplicationContextAware等)，实现这些Aware接口的bean，在被初始化后，可以获得一些相应的资源。如BeanNameAware类的setBeanName , BeanClassLoaderAware类的setBeanClassLoader等
      2. applyBeanPostProcessorsBeforeInitialization 处理器的应用
          再调用客户自定义初始化方法钱记忆调用自定义初始化方法后，会分别调用BeanPostProcessor的postProcessBeforeInitialization和postProcessAfterInitialization方法，根据用户的需求进行响应的处理
      3. invokenInitMethods 
          调用初始化方法，可以是init-method配置，也可以是Bean实现的InitializingBean接口。该方法先检查是否是InitializingBean，如果是，则调用afterPropertiesSet方法，再调用init-method解析方法
    - registerDisposableBeanIfNecessary 根据scope注册bean
      主要是注册destroy-method和DestructionAwareBeanPostProcessor方法

