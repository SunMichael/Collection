# Collection

关于一些iOS知识点的个人认知，代码实践


### 1.copy和mutableCopy     
需要注意对非集合对象的拷贝属于深拷贝。对集合对象的拷贝存在浅拷贝和单层深拷贝

### 2.KVC对对象属性修改的过程      
主要是查找过程，当key不存在对应的属性名时，会查找key，_key，iskey，_iskey这样名字的成员变量，再进行赋值

### 3.KVO的使用
KVO可以对属性进行监听，如果需要对对象内的实例变量监听需要手动实现，在赋值时调用<code>[self willChangeValueForKey:key]</code>和<code>[self didChangeValueForKey:key]</code>

### 4.property的修饰关键字区别
copy修饰的属性，会重新生成一份不可变的拷贝，strong修饰的属性则是强引用指向同一个对象

### 5.对Class，Objc的认识
objc_class: 类结构体里面包含的主要内容，isa指针指向元类，super_class父类，objc_ivar_list成员变量列表，objc_method_list对象方法列表。

objc_protocol_list协议列表以及缓存objc_cache。

objc_object: 对象结构体里面包含的主要内容，isa指针指向它所属的类。

objc_ivar: 实例变量，主要包括ivar_name和ivar_type，属性的实质是 property = ivar + setter + getter。

objc_method: 对象方法，里面包含 sel name , IMP method_imp , method_types。

### 6.<code>[obj method]</code>对象调用方法的过程
1.首先会调用objc_msgSend方法，在实现中如果判断obj为nil则返回nil，如果不为nil则根据obj的isa指针，查找对应的类以及方法列表中是否存在method的实现

2.class_getMethodImplementation方法，在查找Class中的对象方法时，如果方法不存在则使用objc_msgForward进行消息转发

### 7.ARC中autoreleasepool内对象的释放时机
autoreleasepool的释放要结合它当前所在的runloop来判断，当子线程中的runloop即将进入休眠阶段时处在其中的autoreleasepool会被销毁。主线程中的释放池内的对象会一直存在。

### 8.NSLock，pthread_mutex，dispatch_semaphore_t几种锁的使用
1.区分互斥锁(pthread_mutex)和自旋锁(os_unfair_lock) 的区别。     

2.其中pthread分为普通锁和递归锁，区别在于普通锁在某个线程反复操作资源锁时会造成死锁      




