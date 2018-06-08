//
//  PropertyController.m
//  Collection
//
//  Created by mac on 2018/4/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PropertyController.h"
#import "config.h"
@interface PropertyController ()
{
    NSString *share;
}
@end

@implementation PropertyController

static NSString *staticString = @"static";

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"name %p",_name);
    _name = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _author = [[NSString alloc] initWithFormat:@"sun"];
    share = _author;
    
    share = [NSString stringWithFormat:@"abc"];
    TLog(share);
    TLog(staticString);
    
    NSMutableString __unsafe_unretained *mstring = [NSMutableString stringWithFormat:@"mutable"];
    [mstring stringByAppendingString:@"sun"];
    
//    _unsafeAry = [[NSMutableArray alloc] init];
//    [_unsafeAry addObject:@"aaa"];    //会crash
    
    [self stringClass];
    
    
    NSArray *ary = @[@"a"];
    NSLog(@" ary class : %@ ",NSStringFromClass([ary class]));
    NSArray *ary2 = [NSArray arrayWithObject:@"a"];
    NSArray *ary3 = [[NSArray alloc] initWithObjects:@"a", nil];
    NSArray *ary4 = [[NSArray alloc] initWithArray:ary3 copyItems:YES];
    NSLog(@" %p , %p , %p ,%p",ary, ary2 , ary3[0] ,ary4[0]);
    
   
}


- (void)stringClass{
    NSString *string ;
    string = @"abc";       //方法一，会被放到常量内存区里，不会初始化内存空间，app结束后才释放
    NSString *string2 = [NSString stringWithString:@"abc"];    //方法二，autorelease类型
    NSString *string3 = [[NSString alloc] initWithString:@"abc"];    //方法三
   
    //以上三种方式初始化的字符串是NSCFConstantString类型，放到常量内存区，不会初始化内存空间，app结束后才释放
    
    NSString *string4 = [[NSString alloc] initWithFormat:@"%@",@"abc"];
    NSString *string5 = [NSString stringWithFormat:@"abc"];
    
    //以上方式初始化的字符串是NSTaggedPointerString类型，会被分到堆区，初始化内存空间
    
    TLog(string);
    TLog(string2);
    TLog(string3);
    
    //以上三种方式初始化的指针一样
    
    TLog(string4);
    TLog(string5);
    
    //上面也是指针一样，TaggedPointer的好处就是省下一次对象初始化
    
    NSString *mcopy = [[string mutableCopy] copy];
    TLog(mcopy);
    
    //NSNumber 也是TaggedPointer
    NSNumber *number = [NSNumber numberWithUnsignedInteger:1];
    TLog(number);
    
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

/**
 查找view自身所在的controller

 @param view view description
 @return return value description
 */
-(UIViewController *)findController:(UIView*)view
{
    id responder = view;
    while (responder){
        if ([responder isKindOfClass:[UIViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end




/*         TaggedPointer
 *
 *  Tagged Pointer很像一个对象。它能够响应消息，因为objc_msgSend可以识别Tagged Pointer。假设你调用integerValue，它将从那60位中提取数值并返回。这样，每访问一个对象，就省下了一次真正对象的内存分配，省下了一次间接取值的时间。同时引用计数可以是空指令，因为没有内存需要释放。对于常用的类，这将是一个巨大的性能提升。
 *
    这种指针不通过解引用isa来获取其所属类，而是通过接下来三位的一个类表的索引。该索引是用来查找所属类是采用Tagged Pointer的哪个类。剩下的60位则留给类来使用。
 
 *   静态变量，非format初始化的字符串 类型是 NSCFConstantString
 *   format的字符串 类型是NSTaggedPointerString
 *
 *   对不可变对象NSString,NSArray等copy，strong效果一样都是指针拷贝，指向同一个地址，但当对象改变时指针会指向新的地址。
     对可变对象NSMutableString,NSMutableArray等，copy，strong是指针引用，操作的是同一个对象
 
 *   最主要的区别是在可变对象赋值给不可变对象时，copy会产生新的不可变对象，strong则还是指针引用
 */







