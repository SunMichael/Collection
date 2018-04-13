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
