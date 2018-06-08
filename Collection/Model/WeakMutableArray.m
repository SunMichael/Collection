//
//  WeakMutableArray.m
//  Collection
//
//  Created by mac on 2018/5/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "WeakMutableArray.h"

@interface WeakMutableArray ()

@property (nonatomic ,strong) NSPointerArray *pointerAry;
@end

@implementation WeakMutableArray

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pointerAry = [NSPointerArray weakObjectsPointerArray];
    }
    return self;
}

- (void)addObject:(id)obj{
    [_pointerAry addPointer:(__bridge void*)obj];
}

- (id)objectAtWeakArrayIndex:(NSInteger)index{
    return [_pointerAry pointerAtIndex:index];
}


- (NSArray *)allObjects{
    return _pointerAry.allObjects;
}

- (NSInteger)allCount{
    return _pointerAry.count;
}

- (NSInteger)useableCount{
    return _pointerAry.allObjects.count;
}

@end
