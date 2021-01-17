## Spring AOP源码初步跟踪
---

> 参考书籍 《Spring源码深度解析(第2版)》
> 
> 参考连接 <>

---

- 解析入口
  AopNamespaceHandler类中，init方法存在 aspectj-autoproxy ，表示一旦遇到该注解，即创建 AspectJAutoProxyBeanDefinitionParser实例
  ``` java
  @Override
	public void init() {
		registerBeanDefinitionParser("config", new ConfigBeanDefinitionParser());
		registerBeanDefinitionParser("aspectj-autoproxy", new AspectJAutoProxyBeanDefinitionParser());
		registerBeanDefinitionDecorator("scoped-proxy", new ScopedProxyBeanDefinitionDecorator());
		registerBeanDefinitionParser("spring-configured", new SpringConfiguredBeanDefinitionParser());
	}
  ```
  
- AspectJAutoProxyBeanDefinitionParser#parse方法
  所有的解析器，都是对BeanDefinitionParser接口的统一实现，入口都是从parse函数开始
  ``` java
  @Override
	@Nullable
	public BeanDefinition parse(Element element, ParserContext parserContext) {
// 注册AnnotationAwareAspectJAutoProxyCreator
AopNamespaceUtils.registerAspectJAnnotationAutoProxyCreatorIfNecessary(parserContext, element);
//对于注解中子类的处理
		extendBeanDefinition(element, parserContext);
		return null;
	}
  ```
- AopNamespaceUtils#registerAspectJAnnotationAutoProxyCreatorIfNecessary
  该方法的主要作用就是注册AnnotationAutoProxy
  ``` java
  public static void registerAspectJAnnotationAutoProxyCreatorIfNecessary(
			ParserContext parserContext, Element sourceElement) {
			//注册或升级AutoProxyCreator定义的beanName为internalAutoProxyCreator的BeanDifinition
		BeanDefinition beanDefinition = AopConfigUtils.registerAspectJAnnotationAutoProxyCreatorIfNecessary(
				parserContext.getRegistry(), parserContext.extractSource(sourceElement));
				//对于proxy-target-class以及expose-proxy属性的处理
		useClassProxyingIfNecessary(parserContext.getRegistry(), sourceElement);
		registerComponentIfNecessary(beanDefinition, parserContext);
	}
  ```
  
  -  registerAspectJAnnotationAutoProxyCreatorIfNecessary方法
    对于AOP的实现，基本都是靠AnnotationAwareAspectAutoProxyCreator完成，可以根据@Point注解定义的切点来自动代理相匹配的bean。该方法就是spring自动注册AnnotationAwareAspectAutoProxyCreator类。
    该方法中，又接着调用registerOrEscalateApcAsRequired方法，不仅实现了自动注册功能，还涉及一个优先级的问题:如果已经存在了自动代理创建器，而且存在的自动代理创建器与现在的不一致，则需要根据优先级来判断到底使用哪个
  - useClassProxyingIfNecessary方法
    该方法实现了对proxy-target-class属性以及expose-proxy属性的处理。
    ``` java
    private static void useClassProxyingIfNecessary(BeanDefinitionRegistry registry, @Nullable Element sourceElement) {
		if (sourceElement != null) {
			boolean proxyTargetClass = Boolean.parseBoolean(sourceElement.getAttribute(PROXY_TARGET_CLASS_ATTRIBUTE));
			if (proxyTargetClass) {
// 对于proxy-target-class属性的处理			AopConfigUtils.forceAutoProxyCreatorToUseClassProxying(registry);
			}
			boolean exposeProxy = Boolean.parseBoolean(sourceElement.getAttribute(EXPOSE_PROXY_ATTRIBUTE));
			if (exposeProxy) {
			//对expose-proxy属性的处理
			AopConfigUtils.forceAutoProxyCreatorToExposeProxy(registry);
			}
		}
	}
    ```
    强制使用的过程其实也是一个属性设置的过程。
    proxy-target-class:默认为false。springaop提供了JDK动态代理或CGLIB来为目标对象创建代理(建议使用JDK动态代理)。强制使用CGLIB的话，需要将proxy-target-class设置为ture。**JDK动态代理**的代理对象必须是某个接口的实现，通过运行期间创建接口的实现类完成对目标对象的代理。**CGLIB代理**在运行期间生成的代理对象是针对目标类扩展的子类。
    expose-proxy:有时候目标对象内部的自我调用将无法实现切面的增强(常出现在事务的调用中)，可以将expose-proxy设置为true，使用((<T>)AopContext.currentProxy()).methods()方法调用