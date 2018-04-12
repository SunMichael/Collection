//
//  KVCModel.m
//  Collection
//
//  Created by mac on 2018/4/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "KVCModel.h"

@implementation KVCModel
{
    NSString *_password;
    
    NSString *_newName;
}

//// KVO内部实现调用下面2个方法
//- (void)setName:(NSString *)name{
//    [self willChangeValueForKey:@"name"];
//    [super setValue:name forKey:@"name"];
//    [self didChangeValueForKey:@"name"];
//}

/*
 * ========= kvc with array ============
 */
- (instancetype)init{
    if (self = [super init]) {
        _items = [NSMutableArray new];
//        [self addObserver:self forKeyPath:@"items" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"keyPath valueChange: %@", change);
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"items"];
}

- (void)addItem{
    [_items addObject:@(1)];
}

- (void)addItemObserver{
    NSMutableArray *ary = [self mutableArrayValueForKey:@"items"];
    [ary addObject:@(0)];
}

- (void)removeItemObserver{
    [[self mutableArrayValueForKey:@"items"] removeLastObject];
}

/*
 * ========= -setValue: forKey: ============
 */

+ (BOOL)accessInstanceVariablesDirectly{   
    return YES;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //    [super setValue:value forUndefinedKey:key];
    NSLog(@" set出现异常，该key不存在%@ ",key);
}

- (id)valueForUndefinedKey:(NSString *)key{
    NSLog(@" 出现异常，该key不存在%@ ",key);
//    return [super valueForUndefinedKey:key];
    return nil;
}




/*
 * ========= -valueForKey: ============
 */

- (NSString *)getNewName{
    return @"OverGetName";
}

- (NSString *)newName{
    return @"OverName";
}

- (NSUInteger)countOfName{  //自身属性，会自动生成- countOfxxx: , -objectInxxxAtIndex: -xxxAtIndexes: 方法
    NSLog(@" countOf ");
    return 1;
}

- (id)objectInNameAtIndex:(NSUInteger)index{
    NSLog(@" objectInxxxAtIndex ");
    return @(index);
}

- (NSArray *)nameAtIndexes:(NSIndexSet *)indexes{
    NSLog(@" xxxAtIndexes");
    return @[];
}

- (NSInteger)countOfMykey{    //模拟undefined key 过程
    return 10;
}

//- (id)objectInMykeyAtIndex:(NSUInteger)index{
//    return @(2* index);
//}

@end
