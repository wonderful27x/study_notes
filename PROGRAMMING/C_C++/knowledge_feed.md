# 链接指示: extern C
> extern c 指示编译器按照c的风格来编译代码，其中c可是其他语言，这里有两个前提:  
一是我们需有权访问该编译器，二是该编译器与c++编译器兼容

* c++和c编译器对函数的编译是不同的，c++有函数重载编译时通常是函数名加形参类型，而c通常就是函数名
* extern c可以用来引入c代码，在c++中使用
* extern c也可用来修饰一个正在编写的c++代码(注意有很多限制),按照c风格编译，这样c就能调用c++代码
* **__cplusplus**: 是c++预定义的宏，下面语句代表如果是编译c++则使用extern c包含c代码
```
#ifdef __cplusplus
extern "C"{
#enif
//... 声明c风格函数
#ifdef __cplusplus
}
#endif
```

# c++多线程

> 关于c++线程更详细的说明，请阅读[c++手册](https://www.apiref.com/cpp-zh/cpp/thread.html"c++线程支持库")

* **线程的五种状态(这好像是java的概念?!):**
	* 新建状态: 创建新的线程
	* 就绪状态: 调用start()方法，等待获取cpu使用权
	* 运行状态: 获取到cpu使用权，开始执行代码
	* 阻塞状态: 放弃cpu使用权，暂停运行
	* 死亡状态: 线程任务执行完毕或异常退出

* **c++11多线程5个头文件**
```
                           |-- 线程的创建
                |--thread -|--join
                |          |--detach
                |
                |               |--get_id
                |               |--yield
                |--this_thread -|--sleep_for
                |               |--sleep_until
                |
                |         |--mutex
                |--mutex -|--lock_guard
                |         |--unique_lock
                |
                |          |--atomic
        thread -|--atomic -|--atomic_flag
                |
                |                                            
                |                                             |-- wait
                |                                             |-- wait_for
                |                                             |-- wait_until
                |                      |--condition_variable -|-- notify_one
                |                      |                      |-- notify_all
                |                      |                      
                |--condition_variable -|
                |                      |                          |-- wait
                |                      |                          |-- wait_for
                |                      |--condition_variable_any -|-- wait_until
                |                                                 |-- notify_one
                |                                                 |-- notify_all
                |
                |           |-- future
                |-- future -|-- shared_future
                            |-- promise
                            |-- packaged_task
```

* **atomic**
> 当一个操作由两个以上指令完成时，操作可能只执行了一个指令,变量就被另外一个线程抢占，  
数据变得不再完整，这就是非原子操作。c++所有操作默认都是非原子操作。  
	* atomic: 属于原子操作，只有完成和不做两种状态，不会出现数据竞争,保证数据完整性。

* **thread**
	* 构造线程
		* thread不可拷贝构造和拷贝复值，但可移动构造和移动赋值，因此一个thread对象只表示一个线程	
		* 线程构造后就立即开始执行
	* join: 
		* 阻塞当前线程直到\*this所表示的线程结束,
		* 注意线程创建即开始执行，join和线程开始执行无关
	* detach: 
		* 从thread对象分离执行线程，允许执行独立地持续。一但线程退出，则释放任何分配的资源
		* 调用detach后，\*this不再占有任何线程
		* 注意线程创建即开始执行，detatch和线程开始执行无关

* **this_thread命名空间**
	* get_id(): 返回当前线程id
	* yield(): 当前线程进入就绪状态，其他同优先级线程获得运行机会，注意当前线程有可能再次抢到cpu资源运行
	* sleep_for(): 阻塞当前线程，至少经过时间sleep_duration 
	* sleep_until(): 阻塞当前线程，直到到达指定的时间sleep_time

* **mutex**: 互斥量，用于保护共享数据免受多个线程同时访问
	* lock(): 锁定互斥，若另一线程已锁定互斥，则阻塞当前线程，直到获得锁。若当前线程已占有mutex,则行为未定义
	* try_lock(): 尝试锁定互斥，成功返回true，失败返回false。若当前线程已占有mutex,则行为未定义
	* unlock(): 解锁互斥，若当前线程未锁定，则行为未定义	
	* 是公平锁吗？？？

* **lock_guard**: 互斥体包装器，创建时获得互斥所有权，离开作用域调用析构函数，释放互斥量
	* lock_guard(mutex_type &m): 调用m.lock锁定互斥
	* lock_guard(mutex_type &m, adopt_lock_t): 不调用m.lock,认为线程已经占有了互斥，若没有占有则行为未定义
	* 若m先于lock_guard销毁，行为未定义
	* 析构时解锁底层互斥

* **unique_lock**: 互斥包装器
	* unique_lock(mutex_type &m): 调用m.lock锁定互斥
	* unique_lock(mutex_type &m,defer_lock_t): 不锁定互斥
	* unique_lock(mutex_type &m,try_to_lock_t): 调用m.try_lock尝试锁定互斥
	* unique_lock(mutex_type &m,adopt_lock_t): 假定调用方线程已占有m
	* lock(): 锁定互斥，等效调用m.lock()
	* try_lock(): 尝试锁定互斥，等效调用m.try_lock()
	* unlock(): 解锁互斥，若互斥未锁定抛出异常
	* try_lock_for(): ...
	* try_lock_until(): ...
	* 析构时若占有互斥则解锁互斥

* **condition_variable**: 用于阻塞一个线程，或同时阻塞多个线程，直到另一个线程修改了共享变量并通知condition_variable
	* 有意修改共享变量的线程必须:
		* 获得mutex所有权，通常通过lock_guard
		* 在保有锁时进行修改
	* 任何有意在condition_variable上等待的线程必须:
		* 在与用作保护共享变量相同的互斥上获得unique_lock
	* wait(): 
		* 原子解锁lock，并阻塞当前线程，并将它添加到\*this等待线程列表
		* 当被notify唤醒时，自动获得锁。如果条件不成立,继续wait释放锁。否则执行后面代码
		* 带有条件的wait等价于,注意即便不调用notify,过一段时间wait也会被唤醒
```
while (!pred()) {
    wait(lock);
}
```
		* 由上述等价条件得，只有条件为false才会阻塞线程，为true时将会获得锁并解除阻塞
	* wait_for(): ...
	* wait_until(): ...
	* notify_one(): 
		* 若任何线程在\*this上等待，解除阻塞等待的线程之一
		* notify_one的时候通常不应该占有互斥，应先unlock再notify,否则wait被唤醒的线程由于无法获得锁而再次进入wait
	* notify_all(): 唤醒所有等待的线程
	* 注意condition_variable只能与unique_lock一起使用
	* 是公平锁吗???

* **condion_variable_any**: 能与任何锁一起使用

* **Future**: ...

* **wait和sleep的区别**: wait会释放锁，sleep不会

* **公平锁和非公平锁**
	* 公平锁: 当获取不到锁的时候进行排队，notify时根据排队的先后顺序让队首的线程先获得锁
	* 非公平锁: 不保证上面的先后顺序，一个刚到进行lock的线程有可能比等待的人先获得锁

* **悲观锁和乐观锁**
	* 悲观锁: 认为同时操作数据时危险的，操作数据前先加锁，操作完释放锁后其他人才能获得锁，然后再对数据进行操作
	* 乐观锁: 认为操作数据时可以不加锁，等操作完成后需要提交之前对数据进行校验。

* **死锁**
	* 当一个操作需要两个及以上的互斥锁，就有可能发生死锁。多个线程已经获取到其中一个锁，它们又互相等待对方释放另一个
```
Mutex lock1,lock2;
thread1:
        lock1.lock()
        lock2.lock()
        //已经获得了lock1,需要获得lock2,等待thread2释放lock2
        lock1.unlock()
        lock2.unlock()
thread2:
        lock2.lock()
        lock1.lock()
        //已经获得了lock2,需要获得lock1,等待thread1释放lock1
        lock2.unlock()
        lock1.unlock()
```

# socket编程

* [原理和基础知识](../../AV-MEDIA/wonderful_notes/note.odt "计算机网络篇")

## select模型(基于Linux)
> select调用可以做到只通过一个线程以非阻塞(或阻塞)的方式监听多个socket的状态，当状态发生改变(可读、可写、发生错误)时立即返回，  
从而进行读写数据，select模型内部采用轮询的方法实现，当监听的socket数量很大时会比较耗时，这时可采用epoll模型。

* **timeval结构体**
```
struct timeval {
	long tv_sec; //秒
	long tv_usec;//微妙
}
```

* **fd_set结构体**
	* 类似一个集合，存放文件描述符，linux一切皆文件，socket也是一个文件
	* 实现原理: 每个bit对应一个文件描述符fd，比如1字节可表示8个fd,比如  
调用FD_ZERO后set的位为00000000,再调用FD_SET(fd=5,&set)后变为00010000
	* int FD_SERO(int fd, fd_set *fdset) //所有位设置为0
	* int FD_CLR(int fd, fd_set *fdset)  //清除某个fd对应的位
	* int FD_SET(int fd, fd_set *fdset)  //设置某个fd对应的位
	* int FD_ISSET(int fd, fd_set *fdset)//判断某个fd对于的位是否被置位 

* **select函数**: `int select(int maxfdp, fd_set* readfds, fd_set* writefds, fd_set* errorfds, struct timeval* timeout)`
	* maxfdp: 所有文件描述符的最大值加1
	* readfds: 指向fd_set的指针，集合保存着需要读操作的socket fd集合，有可读文件返回值大于0，传入null不关心文件读变化
	* writefds: 指向fd_set的指针，集合保存着需要写操作的socket fd集合，有可写文件返回值大于0,传入null不关心文件写变化
	* errorfds: 上面类似，用于监视发生错误异常的文件
	* timeout: 超时策略
		* 传入null，select将一直阻塞到监视的文件发生变化
		* 时间设置为0,纯粹非阻塞函数，不管监视文件是否有变化立即返回
		* 时间设置为大于0,select调用阻塞，监视文件发生变化或超时都将返回
	* 返回值问题
		* <0: select发生错误
		* \>0: 有文件可读写或发生错误
		* =0: 等待超时，没有可读写或错误文件

> 注意: select调用后根据文件的状态内部会修改fd_set的位，所以每次调用select前需要重新设置监听的fd_set  
> 注意: select调用可以做到非阻塞，但当调用send、recv真正进行数据读写时仍然是阻塞的

## poll和epoll模型
...

//======================C++_Primer[书店程序][1]======================
[1]:<https://github.com/wonderful27x/C-_Primer_Practice/tree/main/bookstore>
//为什么要学习书店程序？
//书店程序是C++_Primer经典用例，使用c++11语言，面向对象的思想解决实际问题
//该程序涵盖了c++语言的众多必备知识点，是对理解和掌握c++的最佳实践之一
//该程序包含的c++知识点(可能有未总结到的)：
//一.基础知识
//	引用
//	指针
//	顶层const，底层const
//	函数，实参和形参，实参的初始化
//	初始化，赋值
//	直接初始化,拷贝初始化
//二.类
//	构造函数,初始值列表，内类初始值，构造函数执行流程, 成员初始化顺序
//	默认构造函数，合成的默认构造函数,默认构造函数调用时机,default
//	拷贝构造函数，拷贝赋值运算符,合成的版本
//	构造函数的explicit显示调用，隐式转换
//	成员函数，inline内联函数，隐式this指针，const限定符
//	运算符重载,成员函数，非成员函数
//	重载的调用运算符(),函数对象
//	名字查找与类的作用于page 254
//	类的访问修饰符
//
//三.模板
//	函数模板
//	类模板
//	模板的实例化
//	特例化
//四.友元
//	友元，类，模板在应用中的关系
//五.IO
//	标准输入，标准输出，标准错误
//	cin,cout,cerr
//六.命名空间
//	using声明，using指示
//	命名空间中的名字查找
//	名字冲突，命名空间污染
//七.头文件/源文件
//	声明和定义
//	什么时候定义在头文件，什么时候定义在源文件
//	模板特例化的影响
//八.异常处理
//	throw和catch,throw异常对象和catch异常声明与静态编译类型的关系
//	异常查找和匹配流程
//	异常处理流程
//	被析构的代码
//	异常处理后代码恢复执行点


//书店程序简介：
//一个用来记录书的销售记录的应用程序
//Book_sale类是销售记录的抽象数据类型,它包含以下关键成员
//bookNo:书本编号，代表一本书籍
//units_sold:代表bookNo对应的这本书的销售数量
//revenue:代表这本书的销售总额
//注意每个Book_sale对象记录的是bookNo对应的这一本书的销售记录
//一个书店会产生很多这样的记录，比如每天的记录，每个月的记录，每年的记录
//因此每个具有相同bookNo的Book_sale对象可以相加以合并这些相同书籍的销售记录


//====================[文本查询程序][2]-接口设计========================
[2]:<https://github.com/wonderful27x/C-_Primer_Practice/tree/main/text_query>
//该程序涵盖的知识点：
//一.OOP面向对象程序设计
//	构造函数(执行流程、成员初始化顺序、子类父类构造函数调用先后顺序)
//	合成版本的拷贝构造函数和拷贝赋值元算符
//	普通类的名字查找
//	继承体系名字查找-函数调用解析过程
//	析构函数(执行流程、成员销毁顺序、子类父类析构函数调用先后顺序)
//	析构函数调用时机
//	虚函数
//	纯虚函数
//	虚函数属性被继承
//	动态绑定
//	抽象类
//	访问控制与继承
//      拷贝控制成员的作用
//      三五法则，什么时候应该定义拷贝控制成员
//      拷贝成员的合成版本规则(普通类和继承体系)
//      被删除的合成拷贝成员规则(普通类和继承体系)
//      移动成员的合成版本规则(普通类和继承体系)
//      被删除的合成移动成员规则(普通类和继承体系)
//      析构函数组织移动操作规则(普通类和继承体系)
//	
//
//二.容器
//	顺序容器vector
//	关联容器map，set
//	有序容器,对关键字的比较要求
//	无序容器
//	可重复关键字/不可重复关键字
//	map的find和下标运算的区别
//	迭代器，迭代器范围
//	关联容器的关键数据成员key_type,mapped_type,value_type
//	pair
//	算法，算法永远不执行容器操作
//
//
//三.动态内存
//	智能指针shared_ptr,make_shared
//	智能指针也是模板
//	引用计数
//	智能指针智能用于动态内存
//
//
//四.其他
//	局部静态对象
//	auto,推演
//	范围for循环



//文本查询应用的继承体系
//在文本查询中TextQuery拥有查询某个单词的能力，但是查询还需要&、|、~等操作，
//它们通常是对某个单词的查询结果的交并集和取反，因此像这样的操作并不适合继承
//TextQuery,而是使用TextQuery,我们将自己封装一套继承体系
//				Query_base
//	    _________________________|____________________
//         |                         |                    |
//	WordQuery                NotQuery             BinaryQuery  
//	                                      ____________|_______
//                                           |                    |
//	                                   AndQuery             OrQuery
//Query_base提供统一查询接口，抽象基类
//WordQuery实现单个单词查询
//NotQuery实现~查询
//BinaryQuery是一个拥有两个查询对象的抽象基类
//AndQuery实现&查询
//OrQuery实现|查询
//
//注意上面是查询操作程序设计的继承体系，对于查询用户我们应该隐藏这些复杂的细节
//因此我们提供一个用户层面的接口Query,是查询程序的使用变得简单
//一个复杂的符合查询设计成这样:
//(查询fiery和bird在一行同时出现，或者一行出现了wind的结果)
//Query q = Query("fiery") & Query("bird") | Query("wind");
//Query于继承体系的关系图:
//                                             |___  WordQuery -> fiery
//                             |___ AndQuery --|___  WordQuery -> bird
//	q = Query -- OrQuery --|
//                             |___ WordQuery -> wind
//
//
// * &运算符生成一个绑定到新的AndQuery对象上的Query对象
// * |运算符生成一个绑定到新的OrQuery对象上的Query对象
// * ~运算符返回一个绑定到新的NotQuery对象上的Query对象


//=================[message folder][3]应用程序===================
[3]:<https://github.com/wonderful27x/C-_Primer_Practice/tree/main/message_copy_move>
//为什么要学习这个程序？
//C++ Primer经典范例，主要教会我们如何在c++程序中正确的使用拷贝控制，
//拷贝控制是c++比较难的点，但是c++程序总会隐式或显示的使用拷贝控制，
//不掌握拷贝控制通常在程序隐式发生拷贝操作时发生令我们无法理解的错误，
//另一方面正确运用拷贝控制往往给程序带来性能提升，所以拷贝控制是难点也是重点

//程序涵盖的知识点:
//	默认构造函数，默认实参,默认构造函数调用时机
//	拷贝控制成员
//	拷贝构造函数,拷贝构造函数调用时机
//	拷贝赋值运算符
//	移动构造函数
//	移动赋值运算符
//	析构函数,析构函数调用时机
//	拷贝控制成员的作用
//	三五法则，什么时候应该定义拷贝控制成员
//	拷贝成员的合成版本规则(普通类和继承体系)
//	被删除的合成拷贝成员规则(普通类和继承体系)
//	移动成员的合成版本规则(普通类和继承体系)
//	被删除的合成移动成员规则(普通类和继承体系)
//	析构函数组织移动操作规则(普通类和继承体系)
//	=default、=delete
//	右值引用
//	std::move
//	拷贝成员参数的const
//	swap
//	using指示和using声明，扩展的重载函数集
//	移动操作保证移后源的安全析构
//	拷贝构造函数，拷贝赋值运算符和析构函数所做的工作
//	移动操作于noexcept
//	赋值运算符的自赋值情况
//	delete,delete 非动态分配的内存，多次delete


//程序简介:
//程序有两个类Message和Folder
//Message代表一个消息，Folder代表消息的目录
//一个Message可以出现在多个Folder中，它拥有一个保存Folder指针的set
//一个Folder包含多个Message,也有一个set保存Message指针
