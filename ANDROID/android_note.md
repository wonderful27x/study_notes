### [目录](#目录)	
1. [android系统四层架构][]
2. [从开机到view被显示出来][]
	1. [系统启动流程][]
	2. [Activity启动流程][]
	3. [view绘制流程（测量、布局、绘制）][]
	4. [事件分发流程][]
3. [高级UI][]
	1. [高级绘制(paint、path、canvas、pathMeasure)][]
	2. [自定义view][]
	3. [动画][]
	4. [屏幕适配][]
4. [架构][]
	1. [MVP][]
	2. [MVVM][]
	3. [JETPACK][]
	4. [AOP][]
	5. [APT][]
	6. [组件化][]
5. [HANDLER][]
6. [BINDER][]
7. [JNI/NDK][]
8. [相机/OPENGL][]
9. [源码级开发][]
	1. [hook][]
	2. [热修复][]
	3. [插件化][]
	4. [虚拟机][]
	5. [AMS][]
	6. [WMS][]
	7. [PMS][]


[^_^]: -------------------------------参考式目录跳转连接--------------------------------------------
[android系统四层架构]: #android系统四层架构  
[从开机到view被显示出来]: #从开机到view被显示出来  
[系统启动流程]: #系统启动流程  
[Activity启动流程]: #activity启动流程  
[view绘制流程（测量、布局、绘制）]: #view绘制流程（测量、布局、绘制）  
[事件分发流程]: #事件分发流程  
[高级UI]: #高级UI  
[高级绘制(paint、path、canvas、pathMeasure)]: #高级绘制(paint、path、canvas、pathMeasure)  
[自定义view]: #自定义view  
[动画]: #动画  
[屏幕适配]: #屏幕适配  
[架构]: #架构  
[MVP]: #MVP  
[MVVM]: #MVVM  
[JETPACK]: #JETPACK  
[AOP]: #AOP  
[APT]: #APT  
[组件化]: #组件化  
[HANDLER]: #HANDLER  
[BINDER]: #BINDER  
[JNI/NDK]: #JNI/NDK  
[相机/OPENGL]: #相机/OPENGL  
[源码级开发]: #源码级开发  
[hook]: #hook  
[热修复]: #热修复  
[插件化]: #插件化  
[虚拟机]: #虚拟机  
[AMS]: #AMS
[WMS]: #WMS
[PMS]: #PMS
[^_^]: -------------------------------参考式目录跳转连接--------------------------------------------


---------------------------------------------------------------------------------------------------


### android系统四层架构
|   四层架构   |
|    :----:    |
| Application  |
| Framework    |
| Library + VM |
| Linux Kernel |


### 从开机到view被显示出来
#### 系统启动流程
1. Boot
	* Book Rom: 开机后引导芯片从固化的ROM里的预设置代码开始执行，然后加载Boot Loader引导程序到RAM
	* Boot Loader: 引导程序检查RAM，初始化硬件参数等
2. 启动Linux内核
3. 启动init进程，它是Linux用户进程
```
AndroidRuntime.cpp:start()
	startJVM()
	ZygoteInit.java:main()
```
4. init进程启动Zygote进程，它是系统第一个Java进程
	* 创建socket
	* 孵化并启动System Server
	* 等待AMS请求
5. Zygote进程孵化出第一个系统进程System Server
	* 启动Binder线程池
	* 创建SystemServiceManager
	* 启动ActivityManagerService、WindowManagerService、PackageManagerService等服务
6. AMS通过socket请求Zygote启动新进程，Zygote创建并启动Launcher应用进程  
	* 请求PMS获取所有安装的应用信息  
	* 在手机屏幕显示应用图标  

> **注意**: Android分为系统进程和应用进程，他们都由Zygote创建。Zygote进程通过复制自身来创建新进程，
他在启动过程中会在内部创建虚拟机VM，每个应用进程都运行在自己的进程中，都有自己独立的VM，每个
VM都是Linux中的一个进程，VM进程、Linux进程、应用进程都可以认为是同一个概念。


#### activity启动流程 
**CI: IApplicationThread**(客户端Binder接口)  
**SI: IActivityManager**(服务端Binder接口)  

| 客户端进程                                        | 服务端进程                                 |
| :----                                             | :----                                      | 
| ActivityThread.AppliactionThread extends CI.Stub  | ActivityManagerService extends SI.Stub     |
| 1. startActivity()                                | 3. startActivity()                         | 
| 2. ActivityManager.getService[^1].startActivity() | 4. app.thread[^2].scheduleLaunchActivity() |
| 5. scheduleLaunchActivity()                       | ...                                        |
| 6. Handler.sendMessage(H.LAUNCH_ACTIVITY)         | ...                                        |
| 7. [handleLaunchActivity][]                       | ...                                        |
| 8. [handleResumeActivity][]                       | ...                                        |

[^1]: 等于服务端Binder接口SI，于是调用由客户端进程到服务端进程  
[^2]: 等于客户端Binder接口CI，因此调用从服务端进程回到客户端进程  

#### handleLaunchActivity

`~~~~~~~~~~~~~~~~~~~~~~~~~|-- classLoader(new Activity)`  
`performLaunchActivity -> |-- attach() -> new PhoneWindow`  
`~~~~~~~~~~~~~~~~~~~~~~~~~|-- Instrumentation.callActvityOnCreate()` -> [onCreate][]()  
`~~~~~~~~~~~~~~~~~~~~~~~~~|-- performStart()` -> [onStart][]()  

#### handleResumeActivity

performResumActivity -> onResume()  

`~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|-- -> ViewRootImpl.set(DecorView,l)`  
`~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|-- -> requestLayout`   
`WindownManagerImpl.addView ->|-- -> scheduleTranversals`  
`~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|-- -> postCallback`   
`~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|-- -> doTranversal~~~~~~~~~`|-- [measure][]	    
`~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|-- -> performTranversals ->`|-- [layout][]	    
`~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`|-- [draw][]	  

```
等价于:  
`~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`|-- [mesure][]
`WindownManagerImpl.addView -> ViewRootImpl.set(DecorView,l) -> requestLayout -> scheduleTranversals ->  postCallback -> doTranversal -> performTranversals -> `|-- [layout][]
`~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`|-- [draw][]
```

[handleLaunchActivity]: #handleLaunchActivity
[handleResumeActivity]: #handleResumeActivity
[onCreate]: #onCreate
[onStart]: #onStart
[measure]: #measure
[layout]: #layout
[draw]: #draw


#### view绘制流程（测量、布局、绘制） 
#### 事件分发流程
