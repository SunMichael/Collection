//
//  GCDController.m
//  Collection
//
//  Created by mac on 2018/4/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "GCDController.h"

@interface GCDController ()

@end

@implementation GCDController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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



@end









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













