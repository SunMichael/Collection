//
//  GCDController.m
//  Collection
//
//  Created by mac on 2018/4/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "GCDController.h"

@interface GCDController ()
{
    unsigned int count;
}
@end

@implementation GCDController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self thread];
}


- (void)semaphore{
    dispatch_semaphore_t sema = dispatch_semaphore_create(4);   //创建一个容量为4的semaphore
    //多并发
    for (NSInteger i = 0; i < 40; i++) {
        
        dispatch_wait(sema, DISPATCH_TIME_FOREVER);   //消耗一个信号量
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@" async operation %ld ", i);
            sleep(1.f);
            dispatch_semaphore_signal(sema);    //新增一个信号量
        });
    }
}


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
//    sale1.qualityOfService = NSQualityOfServiceBackground;
    sale1.name = @"售票1";
    [sale1 start];
    
    
    NSThread *sale2 = [[NSThread alloc] initWithTarget:self selector:@selector(thread2) object:nil];
//    sale2.qualityOfService = NSQualityOfServiceBackground;
    [sale2  start];
    
    [self performSelector:@selector(saleTicket) onThread:sale1 withObject:nil waitUntilDone:NO];
    [self performSelector:@selector(saleTicket) onThread:sale2 withObject:nil waitUntilDone:NO];
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
    [runloop runMode:NSRunLoopCommonModes beforeDate:[NSDate dateWithTimeIntervalSinceNow:10.f]]; //定义runloop结束时间
    [runloop run];
}




- (void)saleTicket{
    
    while (1) {
        @synchronized(self) {  //同步锁
            if (count > 0 ) {
                count--;
                
                NSLog(@" 车票剩余: %d current thread: %@  iscancle: %d", count, [NSThread currentThread].name,[[NSThread currentThread] isCancelled]);
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
                }
            }
        }
    }
    
}


@end


/*
 *  子线程如果在默认runloop中执行完就会自动结束，如果需要线程一直运行，可以设置runloop的结束时间
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
 
 *
 *
 */













