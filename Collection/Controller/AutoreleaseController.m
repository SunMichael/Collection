//
//  AutoreleaseController.m
//  Collection
//
//  Created by mac on 2018/4/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AutoreleaseController.h"

@interface AutoreleaseController ()
{
    
    __weak NSString *weak_auto_string;
    __weak NSString *weak_string2;
}
@end

@implementation AutoreleaseController
__weak NSString *weak_string = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *string = [NSString stringWithFormat:@"ABC"];
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
}

- (void)autoreleasePool{
    
    @autoreleasepool {
        NSString *auto_string = [NSString stringWithFormat:@"CDE"];
        weak_auto_string = auto_string;
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@" __weak string will appear : %@ , %@ ,%@  ", weak_string , weak_auto_string ,weak_string2);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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





