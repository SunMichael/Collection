//
//  ManualKVOModel.m
//  Collection
//
//  Created by mac on 2018/4/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ManualKVOModel.h"

@implementation ManualKVOModel
{
    NSInteger _age;
}

- (void)setAge:(NSInteger)age{
    [self willChangeValueForKey:@"age"];
    _age = age;
    [self didChangeValueForKey:@"age"];
}

- (NSInteger)age{
    return _age;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{      //手动静止key的notification ，不然会通知2次
    if ([key isEqualToString:@"age"]) {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

//下面的是根据声明的属性自动生成的

+ (BOOL)automaticallyNotifiesObserversOfAge{
    return NO;
}

+ (BOOL)automaticallyNotifiesObserversOfName{
    return YES;
}

@end


/*
 * 当setter getter都被重写时，使用_age会报错，因为此时runtime不会自动生成成员变量，需要调用@synthesize 或者 声明变量_age
 */
