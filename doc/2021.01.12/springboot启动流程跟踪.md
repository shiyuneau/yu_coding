## Spring-Boot 启动流程跟踪
> 参考链接 [https://www.cnblogs.com/rolandlee/p/10756560.html]
>
> 参考书籍《Spring源码深度解析(第二版)》
---
- 找到项目中的 Application
- 点击 application.run方法，该方法返回的为 ConfigurableApplicationContext类
- run方法中，主要包含以下流程:
  - 创建StopWatch类 (记录开始时间、结束时间)
  - 获取 SpringApplicationRunListeners
  - 创建 ApplicationArguments
  - 准备 环境 ConfigurableEnvironment
  - 打印 Banner
  - **createApplicationContext()**创建applicationcontext
  - prepareContext 准备context
  - **refreshContext** 刷新context
  - **afterRefresh(context,applicationArguments)** 刷新后数据准备 
- createApplicationContext() SpringApplication类
  - 获取当前的webApplicationType ，根据不同的类型，创建不同的contextClass
    - 默认为AnnotationConfigApplicationContext
    - type=servlet，AnnotationConfigServletWebServerApplicationContext
    - type=reactive, AnnotationConfigReactiveWebServerApplicationContext
  - 根据 contextClass ,调用BeanUtils.instantiateClass方法，创建对应的ApplicationContext对象。(instantiateClass(clazz)->instantiateClass(Constructor)->makeAccessible->getParameterTypes->constructor.newInstance)
- refreshContext(context) 经过一系列的内部调用，最终进入AbstractApplicationContext类中的refresh方法 。该refresh方法即为ClassPathXmlApplicationContext类getBean时的过程。详情见  **ClassPathXmlApplicationContext源码分析**