//
//  RuntimeController.m
//  Collection
//
//  Created by mac on 2018/4/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "RuntimeController.h"
#import "Robot.h"
#import <objc/runtime.h>

@interface RuntimeController ()

@end

@implementation RuntimeController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self runtimeMethod];
}


- (void)runtimeMethod{
    Robot *robot = [Robot new];
    robot.name = @"shadow";
    robot.company = @"sun";
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([Robot class], &count);   //成员变量列表
    for (unsigned int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSLog(@"成员变量: %@",name);
    }
    
    Ivar ivar = class_getInstanceVariable([Robot class], "_name");   //获取指定的成员变量
    object_setIvar(robot, ivar, @"robotdog");      //给成员变量赋值
    NSLog(@" %@ == %@ ",robot.name , object_getIvar(robot, ivar));
    free(ivar);
}



@end


/*
 Ivar 对象成员变量的指针，本质是struct，里面主要有ivar_name, ivar_type
 
 */


/*
 *******   属性和成员变量的区别   *******
 
 
 ***   首先Class的实质是struct 里面的内容有   ***
 
 struct objc_class {
 Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
 
 #if !__OBJC2__
 Class _Nullable super_class                              OBJC2_UNAVAILABLE;
 const char * _Nonnull name                               OBJC2_UNAVAILABLE;
 long version                                             OBJC2_UNAVAILABLE;
 long info                                                OBJC2_UNAVAILABLE;
 long instance_size                                       OBJC2_UNAVAILABLE;
 struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
 struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
 struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
 struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
 #endif
 }
 
 主要是有objc_ivar_list ,objc_method_list 所以属性可以看成是 成员变量 + setget = 属性
 
 
 ***   对象的实质内容   ***
 struct objc_object {
 Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
 };
 
 对象里面有isa指针，指向它的class，class里面有objc_ivar_list（成员变量列表），objc_method_list（对象方法列表）
 */



/*

 
 */


