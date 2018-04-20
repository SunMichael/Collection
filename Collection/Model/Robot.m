//
//  Robot.m
//  Collection
//
//  Created by mac on 2018/4/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "Robot.h"

@implementation Robot
{
    @private NSString *version;
    NSString *systemOS;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        version = @"1.1.0";
        systemOS = @"iOS";
        
        NSLog(@"Class %@ , %@",NSStringFromClass([self class]),NSStringFromClass([super class]));
        // class方法只有NSObject类实现了，并且实现返回object_getClass(self)，所以返回的都是该对象的类
    }
    return self;
}



- (void)run{
    NSLog(@" robot running");
}


- (void)walk{
    NSLog(@" robot walking");
}

- (void)talkToSomeone:(NSString *)name{
    NSLog(@"hello %@",name);
}

@end
