//
//  User.m
//  Collection
//
//  Created by mac on 2018/4/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "User.h"

@implementation User

- (id)copyWithZone:(nullable NSZone *)zone{
    User *user = [[[self class] allocWithZone:zone] init];
    user.age = self.age;
    user.name = self.name;
    user.location = self.location;
    user.mString = self.mString;
    return user;
}


- (void)dealloc{
    NSLog(@" user dealloc...");
}

@end
