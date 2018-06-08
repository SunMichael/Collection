//
//  AutoreleaseController.m
//  Collection
//
//  Created by mac on 2018/4/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AutoreleaseController.h"
#import "User.h"
#import "WeakMutableArray.h"
#import "config.h"

@interface AutoreleaseController ()
{
    __weak NSString *weak_string;
    __weak NSString *weak_auto_string;
    __weak NSString *weak_string2;
    
    NSArray *ary;
}
@end

@implementation AutoreleaseController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    __autoreleasing NSString *string = [NSString stringWithFormat:@"ABC"];
    weak_string = string;
    
//    @autoreleasepool {
//        NSString *auto_string = [NSString stringWithFormat:@"CDE"];
//        weak_auto_string = auto_string;
//    }
    
    NSString *string2 = nil;
    @autoreleasepool {
        string2 = [NSString stringWithFormat:@"BCD"];
        weak_string2 = string2;
    }
    
    
    NSLog(@" __weak string view load : %@ , %@ ,%@  ", weak_string , weak_auto_string ,weak_string2);
    
    [self performSelectorInBackground:@selector(autoreleasePool) withObject:nil];
    
    
    [self arrayRetainObj];
    [self testWeakRelease];
    
    [self objPointAddress];
}

- (void)objPointAddress{
    User *user = [User new];   // user是User类型的指针变量
    user.name = @"name";
    NSLog(@" 一级指针获取对象: %@ \n 一级指针内存地址: %p \n ",user , user );
    

    
    int a = 10;    //声明一个int变量a
//    int* p = 1;   //这样不行，因为int* 只能保持地址
//    int* p = a ;
    int* p = &a ;   //声明一个int型的指针变量 p 通过&取a的地址 然后赋值给p
    *p = 20;        //改变地址下的值
    
    NSLog(@" a : %d  %p\n", a, p);
}

- (void)arrayRetainObj{
    
    /* 一般数组对对象持有是强引用，对象无法被释放,直到数组本身被释放
     * 可以使用NSValue 的valueWithNonretainedObject 对对象进行弱引用，再放到数组当中
     * 或者使用NSPointArray 来保存
     */

    User *user = [User new];
    user.name = @"name";
    ary = [NSArray arrayWithObject:user];
    TLog(user);
    NSLog(@"retain : %@", [user valueForKey:@"retainCount"]);
    
    NSValue *value = [NSValue valueWithNonretainedObject:user];
    ary = [NSArray arrayWithObject:value];
    user = nil;
    user = ary[0];   //此时ary内的user是野指针
//    user.name = @"newname";
    NSLog(@" user = %@", user);
    
    
    User *user2 = [[User alloc] init];
    WeakMutableArray *weakAry = [[WeakMutableArray alloc] init];
    [weakAry addObject:user2];
    NSLog(@" weakAry obj : %@", [weakAry objectAtWeakArrayIndex:0]);
//    user2 = nil;
    id obj = [weakAry objectAtWeakArrayIndex:0] ;   //这里相当于2个指针都指向user2对象
    obj = nil;
    NSLog(@" weakAry %ld  %ld ",(long)weakAry.allCount , (long)weakAry.useableCount);
    TLog(user2);
}

- (void)testWeakRelease{
    
    // __strong 和 __weak 强弱引用的区别
    __strong NSObject *obj = [[NSObject alloc] init];
    //    __strong NSObject *obj1 = obj;
    __weak NSObject *obj2 = obj;
    obj = nil;
    //    NSLog(@" %@ %@ ", obj  ,obj1);
    NSLog(@" %@ %@ ", obj  ,obj2);
}

- (void)autoreleasePool{
    //分线程会有新的runloop，线程结束时，autoreleasepool会被销毁
//    @autoreleasepool {
//        NSString *auto_string = [NSString stringWithFormat:@"CDE"];
//        weak_auto_string = auto_string;
//    }
    
    __autoreleasing NSString *auto_string = [NSString stringWithFormat:@"CDE"];
    weak_auto_string = auto_string;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@" __weak string will appear : %@ , %@ ,%@  ", weak_string , weak_auto_string ,weak_string2);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    RetainCount(weak_string)
    RetainCount(weak_auto_string)
    NSLog(@" __weak string did appear : %@ , %@ ,%@  ", weak_string , weak_auto_string ,weak_string2);
}



@end



/*
 
 runloop的循环如下:
 1.等待消息（或者事件）
 2.将要处理消息
 3.处理消息
 4.处理完成
 5.等待休眠
 1.等待消息
 
 autoreleasepool 在第4阶段后释放，在程序中函数多层调用，一直处于第3阶段中，因此放到autoreleasepool中的对象会一直存在，并不会释放，正如上面的测试代码，weak_string存在主线程的pool中，所以不会被销毁，会存在于各个阶段
 
 什么时候会被释放？

 runloop在正准备处理消息时生成autoreleasepool，在runloop准备休眠时被销毁
 
 如果我们新开一个线程，会有一个新的runloop，在此分线程的runloop中的autoreleasepool在此runloop循环结束后里面的对象就会被销毁，代码示例：[self performSelectorInBackground:@selector(autoreleasePool) withObject:nil];
 
 */





