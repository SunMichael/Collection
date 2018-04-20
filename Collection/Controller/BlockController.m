//
//  BlockController.m
//  Collection
//
//  Created by mac on 2018/4/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BlockController.h"

@interface BlockController ()
{
    NSString *number;
}
@end

static NSString *desc = @"hello";
int age = 10;

@implementation BlockController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self blockMethod];
    
}

- (void)blockMethod{
    __block NSString *string = @"abc";
    __weak NSString *weakString = @"xyz";
    
    number = @"2017";
    NSLog(@" string 地址: %p , %p , %p ,%p , %p",string ,number, desc, self, weakString);
    
    void(^mallocBlock)(void) = ^(){
        NSString *string = @"abc";
        string = @"bcd";
        number = @"2018";
        desc = @"new desc";
        
        NSLog(@" block内 string 地址: %p , %p ,%p",string, number ,desc);
        
    };
    
    __block BlockController *weakSelf = self;
    _block = ^(){
        weakSelf.view.backgroundColor = [UIColor redColor];
        NSLog(@" weak self : %@ , %p " , weakSelf, weakString);
        
    };
    NSLog(@" property block 地址: %p ", _block);
    _block();
    
    
    mallocBlock();
    
    void(^globalBlock)(void) = ^(){
        age = 20;
        NSLog(@" global block %@", desc);
    };
    
    globalBlock();
    
    NSLog(@" block class: %@ %@ ",NSStringFromClass([mallocBlock class]) ,NSStringFromClass([globalBlock class]));
}


@end






/*
 *  在ARC下，block一般类型有2种
 NSGlobalBlock，全局静态block，不会引用外部的局部变量，或者引用的是全局变量
 NSMallocBlock，保存在堆中的block，当静态block访问外部变量之后就会放在堆中
 
 block的实质是一个结构体，里面主要有isa指针，指向自己的类，有desc结构体描述block信息，_forwarding指向自己的地址，还有一个函数指针指向代码块
 局部变量和局部静态变量会被block捕捉成为block的成员变量，全局变量直接引用
 *
 */





