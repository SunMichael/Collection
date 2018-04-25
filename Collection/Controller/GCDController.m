//
//  GCDController.m
//  Collection
//
//  Created by mac on 2018/4/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "GCDController.h"
#import <pthread.h>
#import <libkern/OSAtomic.h>
#import <os/lock.h>

@interface GCDController ()
{
    unsigned int count;
    NSOperationQueue *queue;
    NSLock *lock;
    os_unfair_lock_t unfairlock ;
    __block OSSpinLock oslock;
}
@end

@implementation GCDController

static pthread_mutex_t plock;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //    [self operation];
    
    
    //pthread_mutex  互斥锁 ,可以用OC对象类型NSRecursiveLock
    pthread_mutexattr_t att;
    pthread_mutexattr_init(&att);
    pthread_mutexattr_settype(&att, PTHREAD_MUTEX_RECURSIVE);     //设置锁的类型为递归锁
    pthread_mutex_init(&plock, &att);  //带着属性来初始化锁
    //    pthread_mutex_init(&plock, NULL);  //如果单纯的使用这个初始化方法，当一个线程多次对持有的锁操作时，会发生死锁
    pthread_mutexattr_destroy(&att);
    //    [self pthread_mutex];
    
    //NSLock 锁
    lock = [[NSLock alloc] init];
    
    //    [self thread];
    
    //    [self semaphore];
    
    //    oslock = OS_SPINLOCK_INIT;  //自旋锁不安全，已经被os_unfair_lock替代
    
    
    //    unfairlock = &(OS_UNFAIR_LOCK_INIT);  //代替OSSPinLock 解决优先级反转问题
    //    [self osspinLock];
}


- (void)semaphore{
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);   //创建一个容量为1的semaphore，为1时是同步
    //多线程，访问同一片资源容易发生数据错乱或者是数据安全问题，需要用锁来控制
    for (NSInteger i = 0; i < 40; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_wait(sema, DISPATCH_TIME_FOREVER);   //消耗一个信号量
            sleep(1.f);
            [self printValue:i];
            dispatch_semaphore_signal(sema);    //新增一个信号量
        });
    }
}

- (void)printValue:(NSInteger)value{
    NSLog(@" print value: %ld ",value);
}


- (void)osspinLock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@" low unfairlock ");
        [self dosomething];
        NSLog(@" low unfairunlock ");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@" high unfairlock ");
        [self dosomething];
        NSLog(@" high unfairlock ");
    });
    
}

- (void)dosomething{
    //    unfairlock = &(OS_UNFAIR_LOCK_INIT);
    //    os_unfair_lock_lock(unfairlock);
    //    OSSpinLockLock(oslock);
    //    sleep(4);
    //    OSSpinLockUnlock(oslock);
    //    os_unfair_lock_unlock(unfairlock);
}

//=============    NSThread部分      ==============

- (void)thread{
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadMethod:) object:nil];
    thread.qualityOfService = NSQualityOfServiceBackground;
    NSLog(@" thread start");
    //    [NSThread sleepForTimeInterval:2.f];   //线程暂停,会堵塞主线程 相当于sleep(2.f)
    [thread start];
    NSLog(@" thread start1");
    
    //并发问题，资源竞争
    count = 20;
    NSThread *sale1 = [[NSThread alloc] initWithTarget:self selector:@selector(thread1) object:nil];
    sale1.qualityOfService = NSQualityOfServiceBackground;
    sale1.name = @"售票1";
    [sale1 start];
    
    
    NSThread *sale2 = [[NSThread alloc] initWithTarget:self selector:@selector(thread2) object:nil];
    sale2.qualityOfService = NSQualityOfServiceBackground;
    [sale2  start];
    
    [self performSelector:@selector(saleTicket2) onThread:sale1 withObject:nil waitUntilDone:NO];
    [self performSelector:@selector(saleTicket2) onThread:sale2 withObject:nil waitUntilDone:NO];
}

- (void)threadMethod:(id)sender{
    
    NSLog(@" thread excute: %@  \n  " , [NSThread currentThread]);
}


- (void)thread1{
    [NSThread currentThread].name = @"售票1";
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop runMode:NSRunLoopCommonModes beforeDate:[NSDate date]];  //runloop一直运行
    [runloop run];
}

- (void)thread2{
    [NSThread currentThread].name = @"售票2";
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:2.f]]; //定义runloop结束时间,好像并不会自动cancel
    [runloop run];
}




- (void)saleTicket{
    
    while (1) {
        @synchronized(self) {  //同步锁
            if (count > 0 ) {
                count--;
                
                NSLog(@" 车票剩余: %d current thread: %@  iscancle: %d", count, [NSThread currentThread].name,[[NSThread currentThread] isCancelled]);
                [NSThread sleepForTimeInterval:1.f];
                //            [self performSelector:@selector(saleTicket) withObject:nil];
            }else{
                
                NSLog(@" 车票卖完 ");
                if ([[NSThread currentThread] isCancelled]) {
                    NSLog(@" 线程结束: %@ ",[NSThread currentThread].description);
                    break;
                }else {
                    [[NSThread currentThread] cancel];
                    CFRunLoopStop(CFRunLoopGetCurrent());     //结束runloop
                    NSLog(@" 线程结束手动结束: %@ ", [NSThread currentThread].description);
                    break;
                }
            }
        }
    }
    
}


- (void)saleTicket2{
    
    while (1) {
        //        [lock lock];
        pthread_mutex_lock(&plock);
        if (count > 0 ) {
            count--;
            
            NSLog(@" 车票剩余: %d current thread: %@  iscancle: %d", count, [NSThread currentThread].name,[[NSThread currentThread] isCancelled]);
            [NSThread sleepForTimeInterval:1.f];
        }else{
            
            NSLog(@" 车票卖完 ");
            if ([[NSThread currentThread] isCancelled]) {
                NSLog(@" 线程结束: %@ ",[NSThread currentThread].description);
                break;
            }else {
                [[NSThread currentThread] cancel];
                CFRunLoopStop(CFRunLoopGetCurrent());     //结束runloop
                NSLog(@" 线程结束手动结束: %@ ", [NSThread currentThread].description);
                break;
            }
        }
        //        [lock unlock];
        pthread_mutex_unlock(&plock);
    }
}


- (void)pthread_mutex{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{   //单个线程重复多次操作锁，要使用递归锁(先多次持有资源，最后再多次解锁)
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value){
            pthread_mutex_lock(&plock);
            if (value > 0) {
                NSLog(@" value %d ",value);
                RecursiveBlock(value - 1);
            }
            pthread_mutex_unlock(&plock);
            NSLog(@" unlock ");
        };
        RecursiveBlock(10);
    });
}


//=============    NSOperation部分      ==============


- (void)operation{
    
    //2个NSOperation的子类，本身只有添加任务的方法
    
    NSInvocationOperation *invocation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    //    [invocation start];
    
    
    NSBlockOperation *block = [[NSBlockOperation alloc] init];
    [block addExecutionBlock:^{
        NSLog(@" block thread: %@ ", [NSThread currentThread]);
    }];
    
    [block addExecutionBlock:^{
        NSLog(@" task2 ");
    }];
    //    [block start];
    
    //NSOperation类包含对线程的设置，和线程之前的依赖
    block.qualityOfService = NSQualityOfServiceBackground;
    
    [invocation addDependency:block];    //添加依赖
    
    
    //Queue 会创建新线程，并执行Operation任务
    queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;   //设置最大并发数为1时，是串行队列，大于1时是并行队列
    queue.maxConcurrentOperationCount = 3;
    //    [queue addOperation:invocation];
    [queue addOperations:@[block, invocation] waitUntilFinished:NO];
    [queue addOperationWithBlock:^{
        NSLog(@" queue thread: %@ ", [NSThread currentThread]);
    }];
    queue.qualityOfService = NSQualityOfServiceBackground;
    
    
}





- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [queue cancelAllOperations];
}

- (void)task1{
    NSLog(@" task1 thread: %@ ", [NSThread currentThread]);
}




@end


/*
 *  子线程如果在默认runloop中执行完就会自动结束，如果需要线程一直运行，可以设置runloop的结束时间
 */


/*
 *  NSOperation 是个抽象类，不能用来封装操作，只能使用它的子类，NSInvocationOperation 和 NSBlockOperation
 这2个类使用时，并不会主动开启新的线程，而是在当前线程中执行
 NSOperation 和 NSThread 类似，除了方法的实现是在子类中， 并且对线程的控制也是只读，不能操作
 */



/*
 *      进程和线程的区别
 *
 进程：
 进程是指在系统中正在运行的一个应用程序，比如同时打开微信和Xcode，系统会分别启动2个进程;
 
 每个进程之间是独立的，每个进程均运行在其专用且受保护的内存空间内;
 
 线程：
 一个进程要想执行任务，必须得有线程（每一个进程至少要有一条线程)，是进程中执行运算的最小单位，是进程中的一个实体，是被系统独立调度和分派的基本单位;
 
 一个进程（程序）的所有任务都在线程中执行;
 
 一个程序有且只有一个主线程，程序启动时创建（调用main来启动），主线程的生命周期是和应用程序绑定，程序退出时，主线程也停止;
 
 同一时间内，一个线程只能执行一个任务,若要在1个进程中执行多个任务，那么只能一个个的按顺序执行这些任务（线程的串行);
 线程自己不拥有系统资源，只拥有在运行中必不可少的资源，但它可与同属一个进程的其它线程共享进程所拥有的全部资源;
 
 *       进程和线程比较：
 *
 
 线程是CPU调度（执行任务）的最小单位，是程序执行的最小单元;
 
 进程是CPU分配资源和调度的单位;
 
 一个程序可以对应多个进程，一个进程可以有多个线程，但至少要有一个线程，而一个线程只能属于一个进程;
 
 同一个进程内的线程共享进程的所有资源;
 
 
 *       常见的线程锁

 iOS 实现线程加锁有很多种方式。@synchronized（条件锁）、 NSLock（普通锁） 、 pthread_mutex（互斥锁） 、 dispatch_semaphore_t（互斥锁）、NSRecursiveLock（递归锁）、OSSpinLock(自旋锁)等
 
 互斥锁: 当Thread1占有资源后，Thread2会进入休眠，等待资源被释放，再唤醒Thread2执行
 自旋锁: 当Thread1占有资源后，Thread2会一直等待，资源被释放时立即执行，效率更高，但低优先级线程占有资源时，高优先级线程会一直等待，消耗CPU
 
 *       死锁形成的4种原因
 
 1.互斥条件。 资源在一段时间内只能由一个线程占有
 2.不可抢占。 在资源没被某个线程使用完之前，不能被另一个强行占有
 3.占有且申请。 线程已经占有一个资源，又申请新的资源
 4.循环等待。  thread1等待thread2完成，thread2等待thread1完成
 */













